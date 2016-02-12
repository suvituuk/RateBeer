require 'rails_helper'

include Helpers

describe "User page" do
  it "shows ratings" do
    user = FactoryGirl.create :user
    sign_in(username:"Pekka", password:"Foobar1")
    FactoryGirl.create(:rating3, user: user)
    visit user_path(user)
    
    expect(page).to have_content 15
  end
end