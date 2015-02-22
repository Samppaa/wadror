class Style < ActiveRecord::Base
  include RatingAverage
  has_many :beers
  has_many :ratings, through: :beers

  def get_name
    if name.nil?
      return '-'
    else
      return name
    end
  end


  def self.top(n)
    sorted_by_rating_in_desc_order = Style.all.sort_by{ |b| -(b.average_rating||0) }
    return sorted_by_rating_in_desc_order[1,n]
  end
end
