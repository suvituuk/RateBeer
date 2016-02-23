class Style < ActiveRecord::Base
  include RatingAverage
  has_many :beers
  has_many :ratings, through: :beers
  
  def self.top(n)
    sorted_by_rating_in_desc_order = Style.all.sort_by{ |s| -(s.average_rating||0) }
    if sorted_by_rating_in_desc_order.size < n
      return sorted_by_rating_in_desc_order
    end
    sorted_by_rating_in_desc_order.take(n)
    # palauta listalta parhaat n kappaletta
    # miten? ks. http://www.ruby-doc.org/core-2.1.0/Array.html
  end
end
