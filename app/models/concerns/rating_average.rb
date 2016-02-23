module RatingAverage
  extend ActiveSupport::Concern
  def average_rating
    if ratings.size==0
      return 0
    end
    ratings.inject(0.0) { |summa, luku| summa + luku.score } / ratings.size
  end
end
