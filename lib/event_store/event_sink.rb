require 'securerandom'
require_relative 'database'

class EventSink
  def self.sink(event)
    EventStore.database[:events].insert(
      id: SecureRandom.uuid,
      aggregate_id: event.aggregate_id,
      type: event.type,
      body: Sequel.pg_json(event.body)
    )
  end
end
