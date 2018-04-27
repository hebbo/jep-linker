module Links
  class Validation
    OTHER_SHORTENERS = ["goo.gl", "bit.ly"].freeze

    def self.shortening_service?(long_url)
      begin
        url = URI.parse(long_url)
      rescue URI::InvalidURIError
        return false
      end
      OTHER_SHORTENERS.include?(url.host)
    end
  end
end
