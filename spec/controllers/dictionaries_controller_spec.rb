require 'spec_helper'

describe DictionariesController do
  
  render_views
  
  before :each do
    Text.delete_all
    Api.stub(:permitted?).and_return(double(:status => 200, 
                                             :body => {'authentication' => {'user_id' => 123}}))
    create(:text, app: "webapp_tab_1", context: "payment", name: "foo", locale: "sv-SE", result: "En liten foo", markdown: true)
    create(:text, app: "webapp_tab_1", context: "payment", name: "foo", locale: "no-NO", result: "Ein litta foo")
    create(:text, app: "webapp_tab_1", context: "payment", name: "foo", locale: "en-US", result: "A little foo")
    create(:text, app: "webapp_tab_1", context: "payment", name: "bar", locale: "sv-SE", result: "En liten bar")
    create(:text, app: "webapp_tab_1", context: "payment", name: "bar", locale: "no-NO", result: "Ein litta bar")
    create(:text, app: "webapp_tab_1", context: "checkout", name: "baz", locale: "sv-SE", result: "En liten baz")
    create(:text, app: "lastminute_hotels", context: "payment", name: "fubar", locale: "sv-SE", result: "En liten fubar")
    create(:text, app: "lastminute_hotels", context: "payment", name: "mozz", locale: "sv-SE", result: "En liten mozz")
    request.headers['HTTP_ACCEPT'] = "application/json"
    request.headers['X-API-Token'] = "9876543werdfghuygfc"
  end
  
  
  describe "GET of a dictionary" do
    
    it "should have an ETag header" do
      get :show, app: "webapp_tab_1", locale: "sv-SE"
      response.header['ETag'].should_not be_nil
    end

    it "should not have an Last-Modified header" do
      get :show, app: "webapp_tab_1", locale: "sv-SE"
      response.header['Last-Modified'].should be_nil
    end 
    

    describe "should return" do

      before :each do
        get :show, app: "webapp_tab_1", locale: "sv-SE"
        response.status.should be(200)
        @d = JSON.parse(response.body)
      end
    
      it "a JSON hash" do
        @d.should be_a Hash      
      end

      it "the contexts as top level keys" do
        @d.size.should == 2
        @d['payment'].should_not == nil
        @d['checkout'].should_not == nil
      end

      it "the names as hashes for the top level context keys" do
        @d['payment'].should be_a Hash
        @d['checkout'].should be_a Hash
      end

      it "each name/value pair in the appropriate context hash, using the #html attribute where appropriate" do
        @d['payment'].should == {"foo"=>"<p>En liten foo</p>\n", "bar"=>"En liten bar"}
        @d['checkout'].should == {"baz"=>"En liten baz"}
      end

    end
    
  end
  
end
