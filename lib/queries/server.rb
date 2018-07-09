require 'sinatra'
require 'sinatra/json'

require_relative 'shifts/query_handler'
require_relative 'shifts/query'

class Server < Sinatra::Base
  get '/' do
    404
  end

  get '/shifts' do
    query = Shifts::Query.new(params)
    json Shifts::QueryHandler.handle(query)
   rescue StandardError
     422
  end
end
