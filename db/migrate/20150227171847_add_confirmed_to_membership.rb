class AddConfirmedToMembership < ActiveRecord::Migration
  def change
    add_column :memberships, :confirmed, :boolean

    for u in Membership.all
      u.update_attribute 'confirmed', true
    end
  end
end
