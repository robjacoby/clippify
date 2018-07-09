require 'sequel'

class EventStore
  def self.database
    @@database ||= Sequel.connect('postgres://localhost/clippify_event_store')
    @@database.extension :pg_json
    @@database
  end
end
