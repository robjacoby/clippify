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
      params = {
        start_time: Time.now.iso8601,
        employee_id: SecureRandom.uuid,
        store_id: SecureRandom.uuid,
      }
      post "/shift/#{shift_id}/start", params
      expect(last_response).to be_created
    end

    it 'creates the event in the event store' do
      shift_id = SecureRandom.uuid
      start_time = Time.now
      employee_id = SecureRandom.uuid
      store_id = SecureRandom.uuid
      expect(EventSink)
        .to receive(:sink)
        .with(
          object_having(
            Event,
            aggregate_id: shift_id,
            type: 'shift_started',
            body: {
              start_time: start_time.utc.iso8601,
              employee_id: employee_id,
              store_id: store_id
            }
          )
        )

      params = {
        start_time: start_time.iso8601,
        employee_id: employee_id,
        store_id: store_id
      }
      post "/shift/#{shift_id}/start", params
    end
  end

  describe 'end shift' do
    let(:shift_id) { SecureRandom.uuid }

    before do
      events = [
        Event.new(
          shift_id,
          'shift_started',
          'start_time' => Time.now.utc.iso8601,
          'employee_id' => SecureRandom.uuid,
          'store_id' => SecureRandom.uuid
        ),
      ]

      class_double(EventSource, get_by_aggregate_id: events).as_stubbed_const
    end

    it 'accepts the command' do
      params = {
        end_time: Time.now.iso8601
      }

      post "/shift/#{shift_id}/end", params
      expect(last_response).to be_created
    end

    it 'creates the event in the event store' do
      end_time = Time.now

      expect(EventSink)
        .to receive(:sink)
        .with(
          object_having(
            Event,
            aggregate_id: shift_id,
            type: 'shift_ended',
            body: {
              end_time: end_time.utc.iso8601,
            }
          )
        )
      params = {
        end_time: end_time.iso8601,
      }

      post "/shift/#{shift_id}/end", params
    end
  end

  describe 'scan_item' do
    it 'accepts the command' do
      sale_id = SecureRandom.uuid
      params = {
        item_id: SecureRandom.uuid,
        shift_id: SecureRandom.uuid,
      }
      post "/sale/#{sale_id}/scan_item", params
      expect(last_response).to be_created
    end

    it 'creates the event in the event store' do
      sale_id = SecureRandom.uuid
      item_id = SecureRandom.uuid
      shift_id = SecureRandom.uuid
      expect(EventSink)
        .to receive(:sink)
        .with(
          object_having(
            Event,
            aggregate_id: sale_id,
            type: 'item_scanned',
            body: {
              item_id: item_id,
              shift_id: shift_id,
            }
          )
        )

      params = {
        item_id: item_id,
        shift_id: shift_id,
      }
      post "/sale/#{sale_id}/scan_item", params
    end
  end
end
