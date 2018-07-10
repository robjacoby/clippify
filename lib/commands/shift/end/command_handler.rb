require_relative '../repository'

class Shift::EndCommandHandler
  def self.handle(command)
    shift = Shift::Repository.load(command.shift_id)
    shift.end(command.end_time)
  end
end
