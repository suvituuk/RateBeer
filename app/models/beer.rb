class Beer < ActiveRecord::Base
  include RatingAverage
  validates :name, presence: true
  validates :style, presence: true
  belongs_to :brewery
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user
  
  def to_s
    "#{name}, #{brewery.name}"
  end
  def self.top(n)
    sorted_by_rating_in_desc_order = Beer.all.sort_by{ |b| -(b.average_rating||0) }
    if sorted_by_rating_in_desc_order.size < n
      return sorted_by_rating_in_desc_order
    end
    sorted_by_rating_in_desc_order.take(n)
    # palauta listalta parhaat n kappaletta
    # miten? ks. http://www.ruby-doc.org/core-2.1.0/Array.html
  end
end


