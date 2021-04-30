class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :ingredients
      t.string :caloriespercan
      t.text	:url

      t.timestamps
    end
  end
end
