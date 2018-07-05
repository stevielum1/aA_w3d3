# == Schema Information
#
# Table name: shortened_urls
#
#  id        :bigint(8)        not null, primary key
#  long_url  :string           not null
#  short_url :string           not null
#  user_id   :integer          not null
#

class ShortenedUrl < ApplicationRecord
  include SecureRandom
  
  validates :short_url, presence: true, uniqueness: true
  validate :no_spamming
  
  def self.random_code
    short_url = SecureRandom.urlsafe_base64(12)
    loop do
      break unless ShortenedUrl.exists?(:short_url => short_url)
      short_url = SecureRandom.urlsafe_base64(12)
    end
    short_url
  end
  
  def self.create!(user, long_url)
    short_url = ShortenedUrl.random_code
    ShortenedUrl.create(long_url: long_url, short_url: short_url, user_id: user.id)
  end
  
  belongs_to :submitter,
  primary_key: :id,
  foreign_key: :user_id,
  class_name: :User
  
  has_many :visits,
  primary_key: :id,
  foreign_key: :short_id,
  class_name: :Visit
  
  has_many :visitors,
  -> { distinct },
  through: :visits,
  source: :user
  
  def num_clicks
    self.visits.length
  end
  
  def num_uniques
    self.visitors.count
  end
  
  def num_recent_uniques
    self.visitors.where('visits.created_at > ?', 10.minutes.ago).count 
  end
  
  has_many :taggings,
  primary_key: :id,
  foreign_key: :short_id,
  class_name: :Tagging
  
  has_many :tag_topics,
  through: :taggings,
  source: :tag_topic
  
  private
  def no_spamming
    url_count = ShortenedUrl.select('*')
      .where('created_at > ? AND user_id = ?', 1.minutes.ago, self.user_id)
      .count
      
    if url_count > 5
      errors[:user_id] << "is spamming"
      raise "STOP SPAMMING!"
    end
  end
end
