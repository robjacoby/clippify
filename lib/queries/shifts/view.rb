module Shifts
  class View
    def self.decorate(shifts)
      {
        commands: {
          'end shift': {
            method: 'POST',
            url: '/shift/<shift_id>/end',
          },
        },
        shifts: shifts.map do |shift|
          {
            data: shift,
            queries: { 'view shift': "/shift/#{shift[:id]}" }
          }
        end
      }
    end
  end
end
