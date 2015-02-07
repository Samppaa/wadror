require 'rails_helper'

def create_beer_with_rating(score, user)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beers_with_ratings(*scores, user)
  scores.each do |score|
    create_beer_with_rating(score, user)
  end
end

BeerClubsController
User


describe Beer do
  it "is created correctly if it has name and style" do
    beer = Beer.create name:"Test", style:"Style"

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "is not created without name" do
    beer = Beer.new style:"Style"
    expect(beer).not_to be_valid
  end

  it "is not created without name" do
    beer = Beer.create name:"Test"
    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is the only rated if only one rating" do
    beer = FactoryGirl.create(:beer)
    user = FactoryGirl.create(:user)
    rating = FactoryGirl.create(:rating, beer:beer, user:user)

    expect(user.favorite_beer).to eq(beer)
  end

  it "is the one with highest rating if several rated" do
    user = FactoryGirl.create(:user)
    create_beer_with_rating(10, user)
    best = create_beer_with_rating(25, user)
    create_beer_with_rating(7, user)

    expect(user.favorite_beer).to eq(best)
  end
end
