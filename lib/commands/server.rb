require 'sinatra'
require 'sinatra/json'

require_relative 'shift/start/command_handler'
require_relative 'shift/start/command'

require_relative 'shift/end/command_handler'
require_relative 'shift/end/command'

require_relative 'sale/scan_item/command_handler'
require_relative 'sale/scan_item/command'


class Server < Sinatra::Base
  get '/' do
    404
  end

  post '/shift/:shift_id/start' do
    command = Shift::StartCommand.new(params)
    Shift::StartCommandHandler.handle(command)
    201
  rescue StandardError
    422
  end

  post '/shift/:shift_id/end' do
    command = Shift::EndCommand.new(params)
    Shift::EndCommandHandler.handle(command)
    201
  rescue StandardError => e
    puts e
    422
  end

  post '/sale/:sale_id/scan_item' do
    command = Sale::ScanItemCommand.new(params)
    Sale::ScanItemCommandHandler.handle(command)
    201
  rescue StandardError => e
    puts e
    422
  end
end
