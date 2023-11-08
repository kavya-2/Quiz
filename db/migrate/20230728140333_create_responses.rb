class CreateResponses < ActiveRecord::Migration[7.0]
  def change
    create_table :responses do |t|
      t.boolean :correct
      t.references :question, null: false, foreign_key: true
      t.references :quiz, null: false, foreign_key: true

      t.timestamps
    end
  end
end
