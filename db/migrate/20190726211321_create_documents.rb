class CreateDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :documents do |t|
      t.string :title
      t.text :description
      t.string :author
      t.integer :number_of_pages
      t.date :realized_at
      t.integer :hits
      t.integer :status, default: 0
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
