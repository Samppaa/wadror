require 'rails_helper'

describe "Beer" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff"}
  let!(:brewery) { FactoryGirl.create :brewery, name:"Karhu"}
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "creating beer with valid name works" do
    visit new_beer_path
    fill_in('beer[name]', with:'test')

    click_button('Create Beer')
    #save_and_open_page
    #expect(page).to have_content 'test'
  end

end