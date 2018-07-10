require_relative '../../event_store/event_source'
require_relative '../database'

class SaleCompleter
  def initialize(event_sink)
    @event_sink = event_sink
    @outstanding_sale_totals = Hash.new { |hash, key| hash[key] = 0 }
  end

  def run
    ::Reactors.database[:bookmarks].insert_ignore.insert(reactor: 'SaleCompleter', bookmark: 0)
    bookmark = ::Reactors.database[:bookmarks].where(reactor: 'SaleCompleter')

    loop do
      run_once(bookmark)
      sleep 5
    end
  end

  def run_once(bookmark)
    EventSource.get_after(bookmark.first[:bookmark]) do |event, sequence_id|
      react(event)
      bookmark.update(bookmark: sequence_id)
    end
  end

  def react(event)
    case event.type
    when 'item_scanned'
      @outstanding_sale_totals[event.aggregate_id] += event.body['price']
    when 'cash_payment_made',
         'gift_card_payment_made',
         'credit_card_payment_made'
      @outstanding_sale_totals[event.body['sale_id']] -= event.body['amount']

      if @outstanding_sale_totals[event.body['sale_id']].zero?
        event = Event.new(event.body['sale_id'], 'sale_completed', {
          completed_at: Time.now.utc.iso8601
        })
        @event_sink.sink(event)
      end
    end
  end
end
