class Shift
  UnknownEventError = Class.new(StandardError)

  def initialize(event_sink, id)
    @event_sink = event_sink
    @id = id
  end

  def replay(events)
    events.each do |event|
      case event.type
      when 'shift_started'
        replay_shift_started(event)
      else
        raise UnknownEventError
      end
    end
  end

  def start(start_time, employee_id, store_id)
    event = Event.new(@id, 'shift_started', {
      start_time: format_time(start_time),
      employee_id: employee_id,
      store_id: store_id
    })
    @event_sink.sink(event)
  end

  private

  def replay_shift_started(event)
    @start_time = event.body['start_time']
  end

  def format_time(time)
    time.utc.iso8601
  end
end
