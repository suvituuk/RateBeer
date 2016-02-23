class Brewery < ActiveRecord::Base
include RatingAverage
validates :name, presence: true
validates :year, numericality: { greater_than_or_equal_to: 1042,
                                    less_than_or_equal_to: Proc.new { Time.now.year },
                                    only_integer: true }
scope :active, -> { where active:true }
scope :retired, -> { where active:[nil,false] }
  
has_many :beers, dependent: :destroy
has_many :ratings, through: :beers

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def restart
    self.year = 2016
    puts "changed year to #{year}"
  end
  
  def self.top(n)
    sorted_by_rating_in_desc_order = Brewery.all.sort_by{ |b| -(b.average_rating||0) }
    if sorted_by_rating_in_desc_order.size < n
      return sorted_by_rating_in_desc_order
    end
    sorted_by_rating_in_desc_order.take(n)
    # palauta listalta parhaat n kappaletta
    # miten? ks. http://www.ruby-doc.org/core-2.1.0/Array.html
  end
  
end
