class CreateSynonyms < ActiveRecord::Migration[7.1]
  def change
    create_table :synonyms do |t|
      t.string  :word
      t.string  :synonym
      t.boolean :approved

      t.timestamps
    end
  end
end
