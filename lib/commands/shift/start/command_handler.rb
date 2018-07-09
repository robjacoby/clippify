require_relative '../repository'

class Shift::StartCommandHandler
  def self.handle(command)
    shift = Shift::Repository.load(command.shift_id)
    shift.start(command.start_time)
  end
end
