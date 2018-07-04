class Tagging < ApplicationRecord
  
  belongs_to :shortened_url,
    primary_key: :id,
    foreign_key: :short_id,
    class_name: :ShortenedUrl
    
  belongs_to :tag_topic,
    primary_key: :id,
    foreign_key: :tag_topic_id,
    class_name: :TagTopic
end