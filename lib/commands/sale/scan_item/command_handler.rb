require_relative '../repository'

class Sale::ScanItemCommandHandler
  def self.handle(command)
    sale = Sale::Repository.load(command.sale_id)
    sale.scan_item(command.item_id, command.shift_id, command.price)
  end
end
