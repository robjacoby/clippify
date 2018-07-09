require_relative '../database'

module Shifts
  class Model
    def self.all
      ::Query.database[:shifts].order(:start_time)
    end
  end
end
