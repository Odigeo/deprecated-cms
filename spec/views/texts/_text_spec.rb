require 'spec_helper'

describe "texts/_text", :type => :view do
  
  before :each do                     # Must be :each (:all causes all tests to fail)
    render partial: "texts/text", locals: {text: create(:text, markdown: true)}
    @json = JSON.parse(rendered)
    @u = @json['text']
    @links = @u['_links'] rescue {}
  end
  
  it "has a named root" do
    expect(@u).not_to eq nil
  end


  it "should have three hyperlinks" do
    expect(@links.size).to eq 3
  end

  it "should have a self hyperlink" do
    expect(@links).to be_hyperlinked('self', /texts/)
  end

  it "should have a creator hyperlink" do
    expect(@links).to be_hyperlinked('creator', /api_users/)
  end

  it "should have a updater hyperlink" do
    expect(@links).to be_hyperlinked('updater', /api_users/)
  end


  it "should have an app" do
    expect(@u['app']).to be_a String
  end

  it "should have a context" do
    expect(@u['context']).to be_a String
  end

  it "should have a name" do
    expect(@u['name']).to be_a String
  end

  it "should have a locale" do
    expect(@u['locale']).to be_a String
  end

  it "should have a MIME type" do
    expect(@u['mime_type']).to be_a String
  end

  it "should have a usage field" do
    expect(@u['usage']).to be_a String
  end

  it "should have a result" do
    expect(@u['result']).to be_a String
  end

  it "should have an created_at time" do
    expect(@u['created_at']).to be_a String
  end

  it "should have an updated_at time" do
    expect(@u['updated_at']).to be_a String
  end

  it "should have a lock_version field" do
    expect(@u['lock_version']).to be_an Integer
  end
  
  it "should have a markdown field" do
    expect(@u['markdown']).not_to eq  nil
  end

  it "should have an html field" do
    expect(@u['html']).to be_a String
  end
  
end
