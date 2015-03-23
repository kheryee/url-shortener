class Url < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :long_url, :scope => :user_id
  validates :long_url, length: {minimum: 10}
  validate :validate_url_format
  before_create :generate_short_url


  def validate_url_format
    uri = URI.parse(long_url)
    errors.add(:long_url, "is not a http or https link") unless uri.kind_of?(URI::HTTP) || uri.kind_of?(URI::HTTPS)

  rescue URI::InvalidURIError
    false
  end

  private

  def generate_short_url
    self.short_url = SecureRandom.urlsafe_base64(4, false)
  end
end

