class User < ActiveRecord::Base
  include RatingAverage
  has_secure_password
  def contains_uppercase
    if password !~ /[A-Z]/
      errors.add(:password, "must contain an uppercase character")
    end            
  end
  
  def contains_number
    if password !~ /\d/
      errors.add(:password, "must contain a number")
    end
  end
  
  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end
  
  validates :username, uniqueness: true, 
      length: { minimum: 3,
                maximum: 15 }
  validates :password, length: { minimum: 4 }
  validate :contains_uppercase
  validate :contains_number
      
  
  has_many :ratings, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :beer_clubs, through: :memberships
end
