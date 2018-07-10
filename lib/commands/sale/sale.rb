class Sale
  UnknownEventError = Class.new(StandardError)

  def initialize(event_sink, id)
    @event_sink = event_sink
    @id = id
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

  def scan_item(item_id, shift_id)
    event = Event.new(@id, 'item_scanned', {
      item_id: item_id,
      shift_id: shift_id
    })
    @event_sink.sink(event)
  end

  private

  def replay_scan_item(event)
    @item_id = event.body['item_id']
  end
end
