require_relative '../repository'

class Payment::MakeGiftCardPaymentCommandHandler
  def self.handle(command)
    payment = Payment::Repository.load(command.payment_id)
    payment.make_gift_card_payment(command.amount, command.sale_id, command.gift_card_id)
  end
end
