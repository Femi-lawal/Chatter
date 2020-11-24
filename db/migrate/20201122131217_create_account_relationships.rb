class CreateAccountRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :account_relationships do |t|
      t.integer :follower_id
      t.integer :followed_id
      t.string :status, :string, default: 'pending'

      t.timestamps
    end

    add_index :account_relationships, :follower_id
    add_index :account_relationships, :followed_id
    add_index :account_relationships, [:follower_id, :followed_id], unique: true
    add_index :account_relationships, [:followed_id, :followed_id]
    add_index :account_relationships, [:follower_id, :follower_id]
  end
end
