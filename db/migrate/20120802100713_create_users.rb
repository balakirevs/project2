class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :surname
      t.string :name
      t.string :middle_name
      t.date :birthdate
      t.string :city
      t.string :phone
      t.string :email
      t.string :gender

      t.timestamps
    end
  end
end
