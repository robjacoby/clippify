class Payment
  UnknownEventError = Class.new(StandardError)

  def initialize(event_sink, id)
    @event_sink = event_sink
    @id = id
  end

  def replay(events)
    events.each do |event|
      case event.type
      when 'cash_payment_made'
        replay_cash_payment_made(event)
      else
        raise UnknownEventError
      end
    end
  end

  def make_cash_payment(amount, sale_id)
    event = Event.new(@id, 'cash_payment_made', {
      amount: amount,
      sale_id: sale_id,
    })
    @event_sink.sink(event)
  end

  private

  def replay_cash_payment_made(event)
    @amount = event.body['amount']
    @sale_id = event.body['sale_id']
  end
end
