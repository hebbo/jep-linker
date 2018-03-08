FactoryBot.define do
  factory :user do
    email 'test@example.com'
    password 'f4k3p455w0rd'
  end

  factory :link do
    long_url { "http://host.#{SecureRandom.hex}.com" }
  end
end
