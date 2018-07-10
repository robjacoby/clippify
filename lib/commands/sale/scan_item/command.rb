class Sale::ScanItemCommand
  attr_reader :sale_id, :item_id, :shift_id, :price

  def initialize(params)
    @sale_id = params[:sale_id]
    @item_id = params[:item_id]
    @shift_id = params[:shift_id]
    @price = Integer(params[:price])
  end
end
