class AddTimestampsToShortenedUrls < ActiveRecord::Migration[5.1]
  def change
    add_column :shortened_urls, :created_at, :datetime
    add_column :shortened_urls, :updated_at, :datetime
  end
end
