require_relative 'database'
require_relative 'event'

class EventSource
  def self.get_by_aggregate_id(aggregate_id)
    EventStore.database[:events].
      where(aggregate_id: aggregate_id).
      order(:sequence_id).
      all.map do |row|
        Event.new(row[:aggregate_id], row[:type], row[:body].to_h)
      end
  end

  def self.get_after(sequence_id)
    EventStore.database[:events].
      where(Sequel.lit('sequence_id > ?', sequence_id)).
      order(:sequence_id).
      all.each do |row|
        yield Event.new(row[:aggregate_id], row[:type], row[:body].to_h), row[:sequence_id]
      end
  end
end
