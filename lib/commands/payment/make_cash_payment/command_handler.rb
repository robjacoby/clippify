require_relative '../repository'

class Payment::MakeCashPaymentCommandHandler
  def self.handle(command)
    payment = Payment::Repository.load(command.payment_id)
    payment.make_cash_payment(command.amount, command.sale_id)
  end
end
