class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :ingredients, array: true
      t.string :caloriespercan,
      t.text	:url,
      t.string 	:brand,
      t.string	:product_name,
      t.timestamps
    end
  end
end
