class Membership < ActiveRecord::Base
  belongs_to :beer_club
  belongs_to :user
  validate :club_validation

  def club_validation
    if (user.beer_clubs.find_by id:self.beer_club_id) != nil
      self.errors.add :base, 'You are already a member of this club!'
    end
  end
end
