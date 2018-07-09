require_relative '../../event_store/event_source'
require_relative '../../event_store/event_sink'
require_relative 'shift'

class Shift::Repository
  def self.load(shift_id)
    events = EventSource.get_by_aggregate_id(shift_id)

    shift = Shift.new(EventSink, shift_id)
    shift.replay(events)
    shift
  end
end
