class Sale
  UnknownEventError = Class.new(StandardError)

  SaleItem = Struct.new(:id, :price)

  def initialize(event_sink, id)
    @event_sink = event_sink
    @id = id
    @sale_items = []
  end

  def replay(events)
    events.each do |event|
      case event.type
      when 'scan_item'
        replay_scan_item(event)
      else
        raise UnknownEventError
      end
    end
  end

  def scan_item(item_id, shift_id, price)
    event = Event.new(@id, 'item_scanned', {
      item_id: item_id,
      shift_id: shift_id,
      price: price
    })
    @event_sink.sink(event)
  end

  private

  def replay_scan_item(event)
    @sale_items << SaleItem.new(event.body['item_id'], event.body['price'])
  end
end
