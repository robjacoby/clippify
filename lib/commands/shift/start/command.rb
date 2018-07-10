require 'time'

class Shift::StartCommand
  ShiftRequiresEmployee = Class.new(StandardError)
  ShiftRequiresStore = Class.new(StandardError)

  attr_reader :shift_id, :start_time, :employee_id, :store_id

  def initialize(params)
    @shift_id = params[:shift_id]
    @start_time = Time.parse(params[:start_time])
    @employee_id = params[:employee_id]
    @store_id = params[:store_id]
    raise ShiftRequiresEmployee if @employee_id.nil?
    raise ShiftRequiresStore if @store_id.nil?
  end
end
