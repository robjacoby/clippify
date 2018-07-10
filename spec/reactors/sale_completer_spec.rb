require 'securerandom'
require 'time'
require_relative '../../lib/reactors/sale_completer/sale_completer'

RSpec.describe SaleCompleter do
  describe "the completer" do
    let(:sale_completed_at) { Time.now }
    let(:sale_id) { SecureRandom.uuid }
    let(:payment_id) { SecureRandom.uuid }
    let(:price) { 1000 }

    let(:bookmark) { double("Bookmark", first: {}, update: nil) }

    before do
      # scan item
      scan_event = Event.new(sale_id, 'item_scanned', {
        'item_id' => SecureRandom.uuid,
        'shift_id' => SecureRandom.uuid,
        'price' => price
      })

      # make payment
      payment_event = Event.new(payment_id, 'cash_payment_made', {
        'sale_id' => sale_id,
        'amount' => price
      })

      es = class_double(EventSource).as_stubbed_const

      allow(es).to receive(:get_after)
                     .and_yield(scan_event, 1)
                     .and_yield(payment_event, 2)
    end

    it "results in a 'sale completed' event" do

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
        SaleCompleter.new(EventSink).run_once(bookmark)
      end
    end
  end
end
