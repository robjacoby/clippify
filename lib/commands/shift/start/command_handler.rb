require_relative '../repository'

class Shift::StartCommandHandler
  def self.handle(command)
    shift = Shift::Repository.load(command.shift_id)
    shift.start(command.start_time, command.employee_id, command.store_id)
  end
end
