class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.string :name

      t.timestamps
    end

    create_table :documents_tags do |t|
      t.belongs_to :document, index: true
      t.belongs_to :tag, index: true
    end
  end
end
