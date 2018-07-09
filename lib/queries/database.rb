require 'sequel'

module Query
  def self.database
    @@database ||= Sequel.connect('postgres://localhost/clippify_query')
  end
end
