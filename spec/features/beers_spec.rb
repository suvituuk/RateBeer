require 'rails_helper'

describe "Beer" do
  it "with valid name is saved" do
    visit new_beer_path
    fill_in('beer_name', with:'beer')
    
    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)
  end
  
  it "is not saved without valid name" do
    visit new_beer_path
    fill_in('beer_name', with:'')
    click_button "Create Beer"
    
    expect(Beer.count).to eq(0)
    expect(page).to have_content "Name can't be blank"
  end
end