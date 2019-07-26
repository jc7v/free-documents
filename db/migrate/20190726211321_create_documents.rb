class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :title
      t.text :description
      t.string :author
      t.integer :number_of_pages
      t.date :realized_at
      t.boolean :is_accepted, default: false
      t.integer :hits
      t.boolean :is_refused, default: false
      t.references :user, index: true, foreign_key: true
      t.string :doc_asset

      t.timestamps null: false
    end
  end
end
