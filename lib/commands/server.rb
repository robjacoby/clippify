require 'sinatra'
require 'sinatra/json'

require_relative '../../app'

require_relative 'shift/start/command_handler'
require_relative 'shift/start/command'

require_relative 'shift/end/command_handler'
require_relative 'shift/end/command'

require_relative 'sale/scan_item/command_handler'
require_relative 'sale/scan_item/command'

require_relative 'payment/make_cash_payment/command_handler'
require_relative 'payment/make_cash_payment/command'

require_relative 'payment/make_gift_card_payment/command_handler'
require_relative 'payment/make_gift_card_payment/command'

require_relative 'payment/make_credit_card_payment/command_handler'
require_relative 'payment/make_credit_card_payment/command'

class Server < Sinatra::Base
  get '/' do
    404
  end

  post '/shift/:shift_id/start' do
    command = Shift::StartCommand.new(params)
    Shift::StartCommandHandler.handle(command)
    201
  rescue StandardError => e
    Clippify.logger.debug e.inspect
    422
  end

  post '/shift/:shift_id/end' do
    command = Shift::EndCommand.new(params)
    Shift::EndCommandHandler.handle(command)
    201
  rescue StandardError => e
    Clippify.logger.debug e.inspect
    422
  end

  post '/sale/:sale_id/scan_item' do
    command = Sale::ScanItemCommand.new(params)
    Sale::ScanItemCommandHandler.handle(command)
    201
  rescue StandardError => e
    Clippify.logger.debug e.inspect
    422
  end

  post '/payment/:payment_id/make_cash_payment' do
    command = Payment::MakeCashPaymentCommand.new(params)
    Payment::MakeCashPaymentCommandHandler.handle(command)
    201
  rescue StandardError => e
    Clippify.logger.debug e.inspect
    422
  end

  post '/payment/:payment_id/make_gift_card_payment' do
    command = Payment::MakeGiftCardPaymentCommand.new(params)
    Payment::MakeGiftCardPaymentCommandHandler.handle(command)
    201
  rescue StandardError => e
    Clippify.logger.debug e.inspect
    422
  end

  post '/payment/:payment_id/make_credit_card_payment' do
    command = Payment::MakeCreditCardPaymentCommand.new(params)
    Payment::MakeCreditCardPaymentCommandHandler.handle(command)
    201
  rescue StandardError => e
    Clippify.logger.debug e.inspect
    422
  end
end
