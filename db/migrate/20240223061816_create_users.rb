class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :login_token
      t.datetime :login_token_verified_at
      t.jsonb :summary

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
