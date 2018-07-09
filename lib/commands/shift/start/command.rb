require 'time'

class Shift::StartCommand
  attr_reader :shift_id, :start_time

  def initialize(params)
    @shift_id = params[:shift_id]
    @start_time = Time.parse(params[:start_time])
  end
end
