module RatingAverage
  extend ActiveSupport::Concern
  def average_rating
    ratings.inject(0.0) { |summa, luku| summa + luku.score } / ratings.size
  end
end
