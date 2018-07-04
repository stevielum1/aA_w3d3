class TagTopic < ApplicationRecord
  validates :topic, presence: true
  
  has_many :taggings,
  primary_key: :id,
  foreign_key: :tag_topic_id,
  class_name: :Tagging
  
  has_many :shortened_urls,
  through: :taggings,
  source: :shortened_url
  
  def popular_links
    urls_with_count = self.shortened_urls.joins(:visits)
                        .select('shortened_urls.*, COUNT(*) AS visit_count')
                        .group('shortened_urls.id')
                        .order('COUNT(*) DESC')
                        .limit(5)
                        
    urls_with_count.map do |url|
      [url.short_url, url.visit_count]
    end
  end
end
