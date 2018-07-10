require 'time'

class Payment::MakeGiftCardPaymentCommand
  attr_reader :payment_id, :amount, :sale_id, :gift_card_id

  def initialize(params)
    @payment_id = params[:payment_id]
    @amount = Integer(params[:amount])
    @sale_id = params[:sale_id]
    @gift_card_id = params[:gift_card_id]
  end
end
