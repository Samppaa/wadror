class AddFrozenToUser < ActiveRecord::Migration
  def change
    add_column :users, :isfrozen, :boolean

    for u in User.all
      u.update_attribute 'isfrozen', false
    end
  end
end
