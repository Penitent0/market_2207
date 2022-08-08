class Market
  attr_reader :name,
              :vendors,
              :date

  def initialize(name)
    @date =  Time.now.strftime('%d/%m/%Y')
    @name = name
    @vendors =[]
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.map { |vendor| vendor.name }
  end

  def vendors_that_sell(item)
    @vendors.select { |vendor| vendor.inventory.include?(item) }
  end

  def total_inventory
    item_hash = Hash.new()
    @vendors.each do |vendor|
      vendor.inventory.keys.each do |key|
        item_hash[key] = {quantity: item_quantity(key), vendors: item_vendor(key)}
      end
    end
    item_hash
  end

  def item_quantity(item)
    item_stock = 0
    @vendors.each do |vendor|
      if vendor.inventory.include?(item)
        item_stock += vendor.check_stock(item)
      end
    end
    item_stock
  end

  def item_vendor(item)
    @vendors.select do |vendor|
      vendor.inventory.include?(item)
    end
  end

  def overstocked_items
    @vendors.flat_map { |vendor| vendor.inventory.keys.select { |key| item_quantity(key) > 50 && item_vendor(key).length > 1 }}.uniq
  end

  def sorted_item_list
    @vendors.flat_map { |vendor| vendor.inventory.keys.map { |item| item.name }}.uniq.sort
  end

  def sell(item, amount)
    
  end
end

