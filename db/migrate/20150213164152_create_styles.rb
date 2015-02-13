class CreateStyles < ActiveRecord::Migration
  def change
    create_table :styles do |t|
      t.string :name
      t.text :description

      t.timestamps
    end

    Style.create :name => 'Weizen', :description => 'Weizen beer style'
    Style.create :name => 'Lager', :description => 'Lager beer style'
    Style.create :name => 'Pale ale', :description => 'Pale ale beer style'
    Style.create :name => 'IPA', :description => 'IPA beer style'
    Style.create :name => 'Porter', :description => 'Porter beer style'

    rename_column :beers, :style, :old_style
    add_column :beers, :style_id, :integer
    Beer.reset_column_information

    for b in Beer.all
      beerStyle = b.old_style # string
      styleObject = Style.all.find_by name:beerStyle
      if !styleObject.nil?
        #b.style_id = styleObject.id
        b.update_attribute 'style_id', styleObject.id
      else
        b.update_attribute 'style_id', 1
        #b.style_id = 1
      end
    end

    remove_column :beers, :old_style

  end
end
