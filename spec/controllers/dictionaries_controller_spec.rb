require 'spec_helper'

describe DictionariesController, :type => :controller do
  
  render_views
  
  before :each do
    Text.delete_all
    permit_with 200
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
      expect(response.header['ETag']).not_to be_nil
    end

    it "should not have an Last-Modified header" do
      get :show, app: "webapp_tab_1", locale: "sv-SE"
      expect(response.header['Last-Modified']).to be_nil
    end 
    

    describe "should return" do

      before :each do
        get :show, app: "webapp_tab_1", locale: "sv-SE"
        expect(response.status).to be(200)
        @d = JSON.parse(response.body)
      end
    
      it "a JSON hash" do
        expect(@d).to be_a Hash      
      end

      it "the contexts as top level keys" do
        expect(@d.size).to eq 2
        expect(@d['payment']).not_to eq nil
        expect(@d['checkout']).not_to eq nil
      end

      it "the names as hashes for the top level context keys" do
        expect(@d['payment']).to be_a Hash
        expect(@d['checkout']).to be_a Hash
      end

      it "each name/value pair in the appropriate context hash, using the #html attribute where appropriate" do
        expect(@d['payment']).to eq({"foo"=>"<p>En liten foo</p>\n", "bar"=>"En liten bar"})
        expect(@d['checkout']).to eq({"baz"=>"En liten baz"})
      end

    end
    
  end
  
end
