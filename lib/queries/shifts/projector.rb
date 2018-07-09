require_relative '../../event_store/event_source'
require_relative '../database'

module Shifts
  module Projector
    def self.run
      ::Query.database[:bookmarks].insert_ignore.insert(projector: 'ShiftsProjector', bookmark: 0)
      bookmark = ::Query.database[:bookmarks].where(projector: 'ShiftsProjector')

      loop do
        EventSource.get_after(bookmark.first[:bookmark]) do |event, sequence_id|
          project(event)
          bookmark.update(bookmark: sequence_id)
        end

        sleep 5
      end
    end

    def self.project(event)
      case event.type
      when 'shift_started'
        project_shift_started(event)
      end
    end

    def self.project_shift_started(event)
      ::Query.database[:shifts].insert({
        id: event.aggregate_id,
        start_time: event.body['start_time'],
      })
    end
  end
end

Shifts::Projector.run
