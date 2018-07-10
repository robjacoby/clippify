require_relative '../repository'

class Payment::MakeCreditCardPaymentCommandHandler
  def self.handle(command)
    payment = Payment::Repository.load(command.payment_id)
    payment.make_credit_card_payment(command.amount, command.sale_id, command.credit_card_number, command.expiry, command.cvv)
  end
end
