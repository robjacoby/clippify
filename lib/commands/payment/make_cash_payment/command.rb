require 'time'

class Payment::MakeCashPaymentCommand
  attr_reader :payment_id, :amount, :sale_id

  def initialize(params)
    @payment_id = params[:payment_id]
    @amount = Integer(params[:amount])
    @sale_id = params[:sale_id]
  end
end
