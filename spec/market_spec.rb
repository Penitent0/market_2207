require './lib/market'
require './lib/vendor'
require './lib/item'

RSpec.describe Market do
  context 'when a marker is created it' do
    let!(:market) { Market.new("South Pearl Street Farmers Market") }
    let!(:vendor1)  { Vendor.new("Rocky Mountain Fresh") }
    let!(:vendor2) { Vendor.new("Ba-Nom-a-Nom") }
    let!(:vendor3) { Vendor.new("Palisade Peach Shack") }
    let!(:item1) { Item.new({name: 'Peach', price: "$0.75"}) }
    let!(:item2) { Item.new({name: 'Tomato', price: '$0.50'}) }
    let!(:item3) { Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"}) }
    let!(:item4) { Item.new({name: "Banana Nice Cream", price: "$4.25"}) }
    let!(:item5) { Item.new({name: 'Onion', price: '$0.25'}) }

    it 'instantiates' do
      expect(market).to be_a(Market)
    end

    it 'has details' do
      expect(market.name).to eq("South Pearl Street Farmers Market")
      expect(market.vendors).to eq([])
      expect(market.date).to eq(Time.now.strftime('%d/%m/%Y'))
      allow(market).to receive(:date).and_return("05/11/55")
      expect(market.date).to eq("05/11/55")
    end

    it 'can add vendors and list them' do
      vendor1.stock(item1, 35)
      vendor1.stock(item2, 7)
      vendor2.stock(item4, 50)
      vendor2.stock(item3, 25)
      vendor3.stock(item1, 65)
      market.add_vendor(vendor1)
      market.add_vendor(vendor2)
      market.add_vendor(vendor3)
      expect(market.vendors).to eq([vendor1, vendor2, vendor3])
    end

    it 'can list vendors by name' do 
      vendor1.stock(item1, 35)
      vendor1.stock(item2, 7)
      vendor2.stock(item4, 50)
      vendor2.stock(item3, 25)
      vendor3.stock(item1, 65)
      market.add_vendor(vendor1)
      market.add_vendor(vendor2)
      market.add_vendor(vendor3)
      expect(market.vendor_names).to eq(["Rocky Mountain Fresh", "Ba-Nom-a-Nom", "Palisade Peach Shack"])
    end

    it 'can list vendors that include #item' do
      vendor1.stock(item1, 35)
      vendor1.stock(item2, 7)
      vendor2.stock(item4, 50)
      vendor2.stock(item3, 25)
      vendor3.stock(item1, 65)
      market.add_vendor(vendor1)
      market.add_vendor(vendor2)
      market.add_vendor(vendor3)
      expect(market.vendors_that_sell(item1)).to eq([vendor1, vendor3])
      expect(market.vendors_that_sell(item4)).to eq([vendor2])
    end

    it 'can list total inventory by item and' do
      vendor1.stock(item1, 35)
      vendor1.stock(item2, 7)
      vendor2.stock(item4, 50)
      vendor2.stock(item3, 25)
      vendor3.stock(item1, 65)
      vendor3.stock(item3, 10)
      market.add_vendor(vendor1)
      market.add_vendor(vendor2)
      market.add_vendor(vendor3)
      expect(market.item_quantity(item1)).to eq(100)
      expect(market.item_quantity(item2)).to eq(7)
      expect(market.item_quantity(item3)).to eq(35)
      expect(market.item_quantity(item4)).to eq(50)
      expect(market.item_vendor(item4)).to eq([vendor2])
      expect(market.item_vendor(item1)).to eq([vendor1, vendor3])
      expect(market.total_inventory).to eq({
          item1 => {
          quantity: 100, 
          vendors: [vendor1, vendor3]
          },
          item2 => {
          quantity: 7,
          vendors: [vendor1]
          },
          item4 => {
          quantity: 50,
          vendors: [vendor2]
          },
          item3 => {
          quantity: 35,
          vendors: [vendor2, vendor3]
          }
        })
    end

    it 'has overstocked items method' do
      vendor1.stock(item1, 35)
      vendor1.stock(item2, 7)
      vendor2.stock(item4, 50)
      vendor2.stock(item3, 25)
      vendor3.stock(item1, 65)
      vendor3.stock(item3, 10)
      market.add_vendor(vendor1)
      market.add_vendor(vendor2)
      market.add_vendor(vendor3)
      expect(market.overstocked_items).to eq([item1])
    end

    it 'has sorted item list' do
      vendor1.stock(item1, 35)
      vendor1.stock(item2, 7)
      vendor2.stock(item4, 50)
      vendor2.stock(item3, 25)
      vendor3.stock(item1, 65)
      vendor3.stock(item3, 10)
      market.add_vendor(vendor1)
      market.add_vendor(vendor2)
      market.add_vendor(vendor3)
      expect(market.sorted_item_list).to eq(["Banana Nice Cream", "Peach", "Peach-Raspberry Nice Cream", "Tomato"])
    end

    xit 'has sell method' do
      vendor1.stock(item1, 35)
      vendor1.stock(item2, 7)
      vendor2.stock(item4, 50)
      vendor2.stock(item3, 25)
      vendor3.stock(item1, 65)
      market.add_vendor(vendor1)
      market.add_vendor(vendor2)
      market.add_vendor(vendor3)
      expect(market.sell(item1, 200)).to eq(false)
      expect(market.sell(item5, 1)).to be(false)
      expect(market.sell(item4, 5)).to be (true)
      expect(vendor2.check_stock(item4)).to eq(45)
      expect(market.sell(item1, 40)).to eq(true)
      expect(vendor1.check_stock(item1)).to eq(0)
      expect(vendor3.check_stock(item1)).to eq(60)
    end
  end
end