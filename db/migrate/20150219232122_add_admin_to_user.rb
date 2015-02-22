class AddAdminToUser < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean

    for u in User.all
      u.update_attribute 'admin', true
    end
  end
end
