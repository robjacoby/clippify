require 'sequel'

module Reactors
  def self.database
    @@database ||= Sequel.connect('postgres://localhost/clippify_reactors')
  end
end
