require 'time'

class Payment::MakeCreditCardPaymentCommand
  attr_reader :payment_id, :amount, :sale_id, :credit_card_number, :expiry, :cvv

  def initialize(params)
    @payment_id = params[:payment_id]
    @amount = Integer(params[:amount])
    @sale_id = params[:sale_id]
    @credit_card_number = "#{params[:credit_card_number]}".strip
    @expiry = "#{params[:expiry_month]}/#{params[:expiry_year]}".strip
    @cvv = "#{params[:cvv]}".strip
  end
end
