require_relative 'model'
require_relative 'view'

module Shifts
  class QueryHandler
    def self.handle(_query)
      shifts = Shifts::Model.all
      Shifts::View.decorate(shifts)
    end
  end
end
