require 'time'

class Shift::EndCommand
  attr_reader :shift_id, :end_time

  def initialize(params)
    @shift_id = params[:shift_id]
    @end_time = Time.parse(params[:end_time])
  end
end
