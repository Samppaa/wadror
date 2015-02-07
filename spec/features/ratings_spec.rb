require 'rails_helper'


describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }
  let!(:user2) { FactoryGirl.create :user2 }
  let!(:rating1) { FactoryGirl.create :rating, score: 10, beer:beer1, user:user }
  let!(:rating2) { FactoryGirl.create :rating, score: 20, beer:beer1, user:user2 }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "amount is shown correctly" do
    visit ratings_path
    expect(page).to have_content 'Number of ratings 2'
  end

  it "are shown correctly in the user's page" do
    visit user_path(1)
    expect(page).to have_content 'has made 1 rating'
  end

  it "deleting own rating workd" do
    visit user_path(1)
    click_on("delete")
    expect(page).to have_content 'has made 0 ratings'
  end
end