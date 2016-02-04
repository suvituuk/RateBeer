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
  validates :username, uniqueness: true, 
      length: { minimum: 3 },
      length: { maximum: 15 }
  validates :password, length: { minimum: 4 }
  validate :contains_uppercase
  validate :contains_number
      
  
  has_many :ratings, dependent: :destroy
  has_many :memberships, dependent: :destroy
end
