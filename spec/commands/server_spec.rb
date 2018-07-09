require 'rack/test'
require 'securerandom'
require 'time'
require_relative '../../lib/commands/server'

RSpec.describe Server do
  include Rack::Test::Methods

  def app
    described_class
  end

  it 'works' do
    get '/'
    expect(last_response).to be_not_found
  end

  describe 'start shift' do
    it 'accepts the command' do
      shift_id = SecureRandom.uuid
      params = { start_time: Time.now.iso8601 }
      post "/shift/#{shift_id}/start", params
      expect(last_response).to be_created
    end

    it 'creates the event in the event store' do
      shift_id = SecureRandom.uuid
      start_time = Time.now
      expect(EventSink).to receive(:sink)
                             .with(
                               object_having(
                                 Event,
                                 aggregate_id: shift_id,
                                 type: 'shift_started',
                                 body: { start_time: start_time.utc.iso8601 }
                               )
                             )
      params = { start_time: start_time.iso8601 }
      post "/shift/#{shift_id}/start", params
    end
  end
end
