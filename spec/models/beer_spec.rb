require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "with name and style is saved" do
    beer = Beer.create name:"Beer", style:"Lager"
    
    expect(beer.valid?).to be(true)
    expect(Beer.count).to eq(1)
  end
  
  it "without name is not saved" do
    beer = Beer.create style:"Lager"
    
    expect(beer.valid?).to be(false)
    expect(Beer.count).to eq(0)
  end
  
  it "without style is not saved" do
    beer = Beer.create name:"Beer"
    
    expect(beer.valid?).to be(false)
    expect(Beer.count).to eq(0)
  end
end
