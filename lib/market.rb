class Market
  attr_reader :name,
              :vendors

  def initialize(name)
    @name = name
    @vendors = []
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.map do |vend|
      vend.name
    end
  end

  def vendors_that_sell(item)
    @vendors.find_all do |vend|
      vend.inventory.keys.include?(item)
    end
  end

  def all_items
    @vendors.flat_map do |vendor|
      vendor.inventory.flat_map do |item, amount|
        item
      end
    end.uniq
  end

  def total_quantity(item)
    @vendors.flat_map do |vendor|
      vendor.check_stock(item)
    end.sum
  end

  def total_inventory
    inventory_hash = Hash.new
    all_items.map do |item|
      inventory_hash[item] = {
                                quantity: total_quantity(item),
                                vendors: vendors_that_sell(item)
                              }
    end
    inventory_hash
  end

  def sorted_item_list
    @vendors.flat_map do |vendor|
      vendor.inventory.flat_map do |item, amount|
        item.name
      end
    end.uniq.sort
  end

  def overstocked_items
    all_items.find_all do |item|
      vendors_that_sell(item).count > 1 && total_quantity(item) > 50
    end
  end

  def date
    Time.now.strftime("%d/%m/%Y")
  end

  def sell_items(item, quantity)
    vendors_that_sell(item).each do |vendor|
      if vendor.check_stock(item) >= quantity
        vendor.sell(item, quantity)
        quantity = 0
      else
        quantity -= vendor.check_stock(item)
        vendor.sell(item, vendor.check_stock(item))
      end
    end
  end

  def sell(item, quantity)
    return false if total_inventory[item].nil? ||
    total_quantity(item) < quantity
    sell_items(item, quantity)
    return true
  end
end
