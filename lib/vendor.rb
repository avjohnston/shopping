class Vendor
  attr_reader :name,
              :inventory

  def initialize(name)
    @name = name
    @inventory = {}
  end

  def stock(item, amount)
    if @inventory.keys.include?(item)
      @inventory[item] += amount
    else
      @inventory[item] = amount
    end
  end

  def check_stock(item)
    return 0 if @inventory[item].nil?
    @inventory[item]
  end

  def potential_revenue
    @inventory.map do |item, amount|
      item.price * amount
    end.sum
  end

  def sell(item, quantity)
    @inventory[item] -= quantity
  end
end
