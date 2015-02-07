require 'rails_helper'

def create_beer_with_rating(score, user)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beer_with_rating_and_style(score, style, user)
  beer = FactoryGirl.create(:beer, style:style)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beer_with_rating_and_brewery(score, brewery, user)
  brewery1 = FactoryGirl.create(:brewery, name:brewery)
  beer = FactoryGirl.create(:beer, brewery:brewery1)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beers_with_ratings_and_brewery(*scores, brewery, user)
  scores.each do |score|
    create_beer_with_rating_and_brewery(score, brewery, user)
  end
end

def create_beers_with_ratings_and_style(*scores, style, user)
  scores.each do |score|
    create_beer_with_rating_and_style(score, style, user)
  end
end

def create_beers_with_ratings(*scores, user)
  scores.each do |score|
    create_beer_with_rating(score, user)
  end
end



describe User do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    user.username.should == "Pekka"
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with too short password" do
    user = User.create username:"Pekka", password:"lo2", password_confirmation:"lo2"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with password that has only letters" do
    user = User.create username:"Pekka", password:"lollol", password_confirmation:"lollol"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "favorite rating style" do
    let(:user){FactoryGirl.create(:user)}

    it "works correctly with one beer and one rating" do
      create_beers_with_ratings(20, user)
      expect(user.favorite_style).to eq('Lager')
    end

    it "works correctly with no ratings" do
      expect(user.favorite_style).to eq('-')
    end

    it "works correctly with multiple styles of beers" do
      create_beers_with_ratings_and_style(10,10,10, 'lowalchol', user)
      create_beers_with_ratings_and_style(10,20,10, 'lager', user)
      expect(user.favorite_style).to eq('lager')
    end

  end

  describe "favorite brewery" do
    let(:user){FactoryGirl.create(:user)}

    it "works correctly with one beer and one rating" do
      create_beers_with_ratings(20, user)
      expect(user.favorite_brewery).to eq('anonymous')
    end

    it "works correctly with no ratings" do
      expect(user.favorite_brewery).to eq('-')
    end

    it "works correctly with multiple styles of beers" do
      create_beers_with_ratings_and_brewery(10,10,10, 'test1', user)
      create_beers_with_ratings_and_brewery(10,20,10, 'test2', user)
      expect(user.favorite_brewery).to eq('test2')
    end

  end

  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_beer
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(10, user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(10, 20, 15, 7, 9, user)
      best = create_beer_with_rating(25, user)

      expect(user.favorite_beer).to eq(best)
    end
  end

  it "is the one with highest rating if several rated" do
    user = FactoryGirl.create(:user)
    beer1 = FactoryGirl.create(:beer)
    beer2 = FactoryGirl.create(:beer)
    beer3 = FactoryGirl.create(:beer)
    rating1 = FactoryGirl.create(:rating, beer:beer1, user:user)
    rating2 = FactoryGirl.create(:rating, score:25,  beer:beer2, user:user)
    rating3 = FactoryGirl.create(:rating, score:9, beer:beer3, user:user)

    expect(user.favorite_beer).to eq(beer2)
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end
end