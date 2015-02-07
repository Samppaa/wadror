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
    styles = {}
    stylesAmount = {}

    for rating in ratings
      beerOfRating = rating.beer
      keys = styles.keys
      if !keys.include? beerOfRating.style
        styles[beerOfRating.style] = rating.score
        stylesAmount[beerOfRating.style] = 1;
      else
        styles[beerOfRating.style] += rating.score
        stylesAmount[beerOfRating.style] += 1
      end
    end

    keys = styles.keys

    largest = 0;
    largestKey = '-'

    for key in keys
      average = styles[key]/stylesAmount[key]
      if average > largest
        largest = average
        largestKey = key
      end
    end

    return largestKey
  end

  def favorite_brewery
    breweries = {}
    breweriesAmount = {}

    for rating in ratings
      beerOfRating = rating.beer
      keys = breweries.keys
      if !keys.include? beerOfRating.brewery.name
        breweries[beerOfRating.brewery.name] = rating.score
        breweriesAmount[beerOfRating.brewery.name] = 1;
      else
        breweries[beerOfRating.brewery.name] += rating.score
        breweriesAmount[beerOfRating.brewery.name] += 1
      end
    end

    keys = breweries.keys

    largest = 0;
    largestKey = '-'

    for key in keys
      average = breweries[key]/breweriesAmount[key]
      if average > largest
        largest = average
        largestKey = key
      end
    end

    return largestKey
  end
end
