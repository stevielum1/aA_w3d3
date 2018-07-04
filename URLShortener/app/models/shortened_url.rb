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
  
  
end
