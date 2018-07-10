require_relative '../../event_store/event_source'
require_relative '../../event_store/event_sink'
require_relative 'sale'

class Sale::Repository
  def self.load(sale_id)
    events = EventSource.get_by_aggregate_id(sale_id)

    sale = Sale.new(EventSink, sale_id)
    sale.replay(events)
    sale
  end
end
