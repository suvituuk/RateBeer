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
  
  
  def favorite_style
    favorite :style
  end

  def favorite_brewery
    favorite :brewery
  end
  
  def favorite(category)
    return nil if ratings.empty?

    rated = ratings.map{ |r| r.beer.send(category) }.uniq
    rated.sort_by { |item| -rating_of(category, item) }.first
  end
  
  private

  def rating_of(category, item)
    ratings_of = ratings.select{ |r| r.beer.send(category)==item }
    ratings_of.map(&:score).inject(&:+) / ratings_of.count.to_f
  end
  
  def self.most_active(n)
   sorted_by_number_of_ratings = User.all.sort_by{ |u| -(u.ratings.size||0) }
   if sorted_by_number_of_ratings.size < n
      return sorted_by_number_of_ratings
    end
   sorted_by_number_of_ratings.take(n)
   # palauta listalta parhaat n kappaletta
   # miten? ks. http://www.ruby-doc.org/core-2.1.0/Array.html
 end
end
