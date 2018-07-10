class Shift
  UnknownEventError = Class.new(StandardError)
  ShiftNotStartedError = Class.new(StandardError)

  def initialize(event_sink, id)
    @event_sink = event_sink
    @id = id
  end

  def replay(events)
    events.each do |event|
      case event.type
      when 'shift_started'
        replay_shift_started(event)
      when 'shift_ended'
        replay_shift_ended(event)

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

  def end(end_time)
    raise ShiftNotStartedError if @start_time.nil?

    event = Event.new(@id, 'shift_ended', {
      end_time: format_time(end_time),
    })

    @event_sink.sink(event)
  end



  private

  def replay_shift_started(event)
    @start_time = event.body['start_time']
  end

  def replay_shift_ended(event)
    @end_time = event.body['end_time']
  end

  def format_time(time)
    time.utc.iso8601
  end
end
