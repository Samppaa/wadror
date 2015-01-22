module RatingAverage
  def average_rating
    a = Array.new;
    self.ratings.each do |r|
      a.append(r.score);
    end

    if self.ratings.count > 0
      return a.inject(0.0) { |sum,n| (sum+n)}/self.ratings.count
    else
      return 0;
    end
  end
end