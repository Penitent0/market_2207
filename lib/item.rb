class Item
  attr_reader :name,
              :price

  def initialize(details)
    @name = details[:name]
    @price = details[:price].gsub('$', '').to_f
  end
end
