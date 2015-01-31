class Brewery < ActiveRecord::Base
  include RatingAverage
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers
  validates :name, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 1042 }
  validate :validate_year

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def validate_year
    self.errors.add :year , 'must be less than or equal to ' << Date.today.year.to_s unless year <= Date.today.year
  end



  def restart
    self.year = 2015
    puts "changed year to #{year}"
  end
end
