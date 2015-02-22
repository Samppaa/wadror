class User < ActiveRecord::Base
  include RatingAverage
  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  has_secure_password
  validates :username, uniqueness: true,
            length: { minimum: 3, maximum: 15 }
  validates :password, length: {minimum: 4}, format: { with: /(?=.*[A-Z])(?=.*\d)/, message: "must contain at least one capital letter and one number"}

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end



  def favorite_style
    favorite :style
  end

  def favorite_style_name
    s = favorite_style
    if s.nil?
      return '-'
    else
      return s.name
    end
  end

  def rated(category)
    ratings.map{ |r| r.beer.send(category) }.uniq
  end

  def rating_of(category, item)
    ratings_of_item = ratings.select do |r|
      r.beer.send(category) == item
    end
    ratings_of_item.map(&:score).sum / ratings_of_item.count
  end

  def favorite(category)
    return nil if ratings.empty?

    category_ratings = rated(category).inject([]) do |set, item|
      set << {
          item: item,
          rating: rating_of(category, item) }
    end

    category_ratings.sort_by { |item| item[:rating] }.last[:item]
  end


  def favorite_brewery
    favorite :brewery
  end

  def favorite_brewery_name
    b = favorite_brewery
    if b.nil?
      return '-'
    else
      return b.name
    end

  end
end
