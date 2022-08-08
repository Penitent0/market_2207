require './lib/item'

RSpec.describe Item do
  context 'when an item is created it' do
    let!(:item1) { Item.new({name: 'Peach', price: "$0.75"}) }
    let!(:item2) { Item.new({name: 'Tomato', price: '$0.50'}) }

    it 'instantiates' do
      expect(item1).to be_a(Item)
    end

    it 'has details' do 
      expect(item2.name).to eq('Tomato')
      expect(item2.price).to eq(0.5)
    end
  end
end