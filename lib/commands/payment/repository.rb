require_relative '../../event_store/event_source'
require_relative '../../event_store/event_sink'
require_relative 'payment'

class Payment::Repository
  def self.load(payment_id)
    events = EventSource.get_by_aggregate_id(payment_id)

    payment = Payment.new(EventSink, payment_id)
    payment.replay(events)
    payment
  end
end
