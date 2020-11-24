class CreateChaats < ActiveRecord::Migration[5.2]
  def change
    create_table :chaats, id: :uuid do |t|
      t.string :chaat_body
      t.references :account, index: true, foreign_key: true

      t.timestamps
    end
    add_index :chaats, [:account_id, :created_at]
  end
end
