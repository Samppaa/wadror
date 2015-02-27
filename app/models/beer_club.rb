class BeerClub < ActiveRecord::Base
  has_many :memberships
  has_many :users, through: :membership

  def to_s
    self.name
  end

  def isMemberAndConfirmed(user)
    u = self.memberships.find_by(user_id: user.id, beer_club_id: self.id)
    if u.nil?
      return false
    elsif !u.confirmed
      return false
    else
      return true
    end
  end

  def hasAppliedTo(user)
    u = self.memberships.find_by(user_id: user.id, beer_club_id: self.id)
    if !u.nil? and !u.confirmed
      return true
    else
      return false
    end
  end

end
