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
        price: 1000
      }
      post "/sale/#{sale_id}/scan_item", params
      expect(last_response).to be_created
    end

    it 'creates the event in the event store' do
      sale_id = SecureRandom.uuid
      item_id = SecureRandom.uuid
      shift_id = SecureRandom.uuid
      price = 1000

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
                    price: price
                  }
                )
              )

      params = {
        item_id: item_id,
        shift_id: shift_id,
        price: price
      }

      post "/sale/#{sale_id}/scan_item", params
    end
  end

  describe 'make_cash_payment' do
    it 'accepts the command' do
      payment_id = SecureRandom.uuid
      params = {
        amount: 1000,
        sale_id: SecureRandom.uuid
      }
      post "/payment/#{payment_id}/make_cash_payment", params
      expect(last_response).to be_created
    end

    it 'creates the event in the event store' do
      sale_id = SecureRandom.uuid
      payment_id = SecureRandom.uuid
      amount = 1000
      expect(EventSink)
        .to receive(:sink)
              .with(
                object_having(
                  Event,
                  aggregate_id: payment_id,
                  type: 'cash_payment_made',
                  body: {
                    sale_id: sale_id,
                    amount: amount
                  }
                )
              )

      params = {
        sale_id: sale_id,
        amount: amount
      }
      post "/payment/#{payment_id}/make_cash_payment", params
    end
  end

  describe 'make_gift_card_payment' do
    it 'accepts the command' do
      payment_id = SecureRandom.uuid
      params = {
        amount: 1000,
        sale_id: SecureRandom.uuid,
        gift_card_id: SecureRandom.uuid
      }
      post "/payment/#{payment_id}/make_gift_card_payment", params
      expect(last_response).to be_created
    end

    it 'creates the event in the event store' do
      sale_id = SecureRandom.uuid
      payment_id = SecureRandom.uuid
      gift_card_id = SecureRandom.uuid
      amount = 1000
      expect(EventSink)
        .to receive(:sink)
              .with(
                object_having(
                  Event,
                  aggregate_id: payment_id,
                  type: 'gift_card_payment_made',
                  body: {
                    sale_id: sale_id,
                    gift_card_id: gift_card_id,
                    amount: amount
                  }
                )
              )

      params = {
        sale_id: sale_id,
        gift_card_id: gift_card_id,
        amount: amount
      }
      post "/payment/#{payment_id}/make_gift_card_payment", params
    end
  end

  describe 'make_credit_card_payment' do
    it 'accepts the command' do
      payment_id = SecureRandom.uuid
      params = {
        amount: 1000,
        sale_id: SecureRandom.uuid,
        credit_card_number: 4123456789012346,
        expiry_month: 12,
        expiry_year: 2020,
        cvv: 123
      }
      post "/payment/#{payment_id}/make_credit_card_payment", params
      expect(last_response).to be_created
    end

    it 'creates the event in the event store' do
      sale_id = SecureRandom.uuid
      payment_id = SecureRandom.uuid
      credit_card_number = 4123456789012346
      expiry_month = 12
      expiry_year = 2020
      cvv = 123
      amount = 1000
      expect(EventSink)
        .to receive(:sink)
              .with(
                object_having(
                  Event,
                  aggregate_id: payment_id,
                  type: 'credit_card_payment_made',
                  body: {
                    sale_id: sale_id,
                    amount: amount,
                    credit_card_number: credit_card_number.to_s,
                    expiry: "#{expiry_month}/#{expiry_year}",
                    cvv: cvv.to_s,
                  }
                )
              )

      params = {
        sale_id: sale_id,
        credit_card_number: credit_card_number,
        expiry_month: expiry_month,
        expiry_year: expiry_year,
        amount: amount,
        cvv: cvv,
      }
      post "/payment/#{payment_id}/make_credit_card_payment", params
    end
  end

  fdescribe "the payment process" do
    let(:sale_completed_at) { Time.now }
    let(:sale_id) { SecureRandom.uuid }
    let(:payment_id) { SecureRandom.uuid }
    let(:price) { 1000 }

    it "results in a 'sale completed' event" do

      # scan item
      post "/sale/#{sale_id}/scan_item", { item_id: SecureRandom.uuid, shift_id: SecureRandom.uuid, price: price }

      # make payment
      post "/payment/#{payment_id}/make_cash_payment", { sale_id: sale_id, amount: price }

      # set up expectation
      expect(EventSink)
        .to receive(:sink)
        .with(
          object_having(
            Event,
            aggregate_id: sale_id,
            type: 'sale_completed',
            body: {
              completed_at: sale_completed_at.utc.iso8601
            }
          )
        )

      Timecop.freeze(sale_completed_at) do
        # run reactor
      end
    end
  end
end
