require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end
  
  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end
  
  it "is not saved with too short password" do
    user = User.create username:"Pekka", password:"P1", password_confirmation:"P1"
    
    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end
  
  it "is not saved if password doesn't contain numbers" do
    user = User.create username:"Pekka", password:"Secret", password_confirmation:"Secret"
    
    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end
  
  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }
    
    it "is saved" do
      expect(user.valid?).to be(true)
      expect(User.count).to eq(1)
    end
  
    it "and two ratings, has the correct average rating" do
      rating = Rating.new score:10
      rating2 = Rating.new score:20

      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end
  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }
    
    it "has method for determining the favorite_beer" do
      user = FactoryGirl.create(:user)
      expect(user).to respond_to(:favorite_beer)
    end
  
    it "without ratings does not have a favorite beer" do
      user = FactoryGirl.create(:user)
      expect(user.favorite_beer).to eq(nil)
    end
    it "is the only rated if only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)

      expect(user.favorite_beer).to eq(beer)
    end
    it "is the one with highest rating if several rated" do
      create_one_with_rating(user, 10)
      best = create_one_with_rating(user, 25)
      create_one_with_rating(user, 7)

      expect(user.favorite_beer).to eq(best)
    end
  end
  
  describe "favorite style" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the style of the only rated if only one rating" do
      beer = FactoryGirl.create(:beer, style:"IPA")
      rating = FactoryGirl.create(:rating, beer:beer, user:user)

      expect(user.favorite_style).to eq("IPA")
    end

    it "is the style with highest average score if several rated" do
      brewery = FactoryGirl.create(:brewery)
      create_beers_with_ratings(user, "lager", brewery, 10, 20, 15, 7, 9)
      create_beers_with_ratings(user, "IPA", brewery, 25, 20)
      create_beers_with_ratings(user, "stout", brewery, 20, 23, 22)

      expect(user.favorite_style).to eq("IPA")
    end
  end

  describe "favorite brewery" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the brewery of the only rated if only one rating" do
      brewery = FactoryGirl.create(:brewery)
      beer = FactoryGirl.create(:beer, brewery: brewery )
      FactoryGirl.create(:rating, beer:beer, user:user)

      expect(user.favorite_brewery).to eq(brewery)
    end

    it "is the brewery with highest average score if several rated" do
      brewery1 = FactoryGirl.create(:brewery)
      brewery2 = FactoryGirl.create(:brewery)
      brewery3 = FactoryGirl.create(:brewery)
      create_beers_with_ratings(user, "lager", brewery1, 10, 20, 15, 7, 9)
      create_beers_with_ratings(user, "IPA", brewery2, 25, 20)
      create_beers_with_ratings(user, "stout", brewery3, 20, 23, 22)

      expect(user.favorite_brewery).to eq(brewery2)
    end
  end
end

def create_beers_with_ratings(user, style, brewery, *scores)
  scores.each do |score|
    create_beer_with_rating(user, style, brewery, score)
  end
end

def create_beer_with_rating(user, style, brewery, score)
  beer = FactoryGirl.create(:beer, style:style, brewery:brewery)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_one_with_rating(user, score)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end