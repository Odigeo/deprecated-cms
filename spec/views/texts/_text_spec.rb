require 'spec_helper'

describe "texts/_text" do
  
  before :each do                     # Must be :each (:all causes all tests to fail)
    render partial: "texts/text", locals: {text: create(:text, markdown: true)}
    @json = JSON.parse(rendered)
    @u = @json['text']
    @links = @u['_links'] rescue {}
  end
  
  it "has a named root" do
    @u.should_not == nil
  end


  it "should have three hyperlinks" do
    @links.size.should == 3
  end

  it "should have a self hyperlink" do
    @links.should be_hyperlinked('self', /texts/)
  end

  it "should have a creator hyperlink" do
    @links.should be_hyperlinked('creator', /api_users/)
  end

  it "should have a updater hyperlink" do
    @links.should be_hyperlinked('updater', /api_users/)
  end


  it "should have an app" do
    @u['app'].should be_a String
  end

  it "should have a context" do
    @u['context'].should be_a String
  end

  it "should have a name" do
    @u['name'].should be_a String
  end

  it "should have a locale" do
    @u['locale'].should be_a String
  end

  it "should have a MIME type" do
    @u['mime_type'].should be_a String
  end

  it "should have a usage field" do
    @u['usage'].should be_a String
  end

  it "should have a result" do
    @u['result'].should be_a String
  end

  it "should have an created_at time" do
    @u['created_at'].should be_a String
  end

  it "should have an updated_at time" do
    @u['updated_at'].should be_a String
  end

  it "should have a lock_version field" do
    @u['lock_version'].should be_an Integer
  end
  
  it "should have a markdown field" do
    @u['markdown'].should_not ==  nil
  end

  it "should have an html field" do
    @u['html'].should be_a String
  end
  
end
