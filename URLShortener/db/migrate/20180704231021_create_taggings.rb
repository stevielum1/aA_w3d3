class CreateTaggings < ActiveRecord::Migration[5.1]
  def change
    create_table :taggings do |t|
      t.integer :short_id, null: false
      t.integer :tag_topic_id, null: false
      t.timestamps
    end
    
    add_index :taggings, [:short_id, :tag_topic_id], unique: true
    add_index :taggings, :short_id
    add_index :taggings, :tag_topic_id
  end
end
