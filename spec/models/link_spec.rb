require 'rails_helper'

RSpec.describe Link, type: :model do
  let(:long_url) { "http://cultureamp.com" }
  let(:custom_url) { "ca" }

  it "generates a short URL if no custom URL" do
    link = Link.create!(long_url: long_url)
    expect(link.short_url).to be_present
  end

  it "does not allow custom URLs that are longer than 20 chars" do
    too_long = "a" * 21
    invalid_link = Link.create(long_url: "foo.com", short_url: too_long)
    expect(invalid_link).to_not be_valid
  end

  it "downcases long_url and short_url" do
    mixed_case = Link.create(long_url: "http://gOOglE.CoM", short_url: "GoOgle")
    expect(mixed_case.long_url).to eq("http://google.com")
    expect(mixed_case.short_url).to eq("google")
  end

  it "does not create entries with same short_url" do
    Link.create!(long_url: long_url, short_url: custom_url)
    dup_link = Link.create(long_url: "http://test.com", short_url: custom_url)
    expect(dup_link).to_not be_valid
    expect(dup_link.errors[:short_url]).to eq(["has already been taken"])
  end

  it "does not accept invalid URLs" do
    invalid_link = Link.create(long_url: "foobar")
    expect(invalid_link).to_not be_valid
  end
end
