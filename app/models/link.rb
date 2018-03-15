class Link < ApplicationRecord
  before_save :build_short_url, on: :create
  before_save { long_url.downcase! }

  validate :not_a_shortening_service
  validates :long_url,
            format: { with: /\A#{URI::regexp(%w(http https))}\z/,
                      message: "Invalid URL format" },
            presence: true
  validates :short_url,
            uniqueness: true,
            length: { maximum: 20, minimum: 1 },
            allow_blank: true,
            format: { without: /\Alinks\z/ }

  belongs_to :user, optional: true

  private

  def build_short_url
    if short_url.blank?
      self.short_url = Links::Builder.generate_short_url
    else
      self.is_custom_url = true
      short_url.downcase!
    end
  end

  def not_a_shortening_service
    if Links::Validation.shortening_service?(long_url)
      errors.add(:long_url_error, "- shortening service not allowed in long URL")
    end
  end
end
