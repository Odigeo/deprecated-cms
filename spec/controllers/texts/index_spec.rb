require 'spec_helper'

describe TextsController, :type => :controller do
  
  describe "INDEX" do

    render_views
    
    before :each do
      permit_with 200
      create :text
      create :text
      create :text
      request.headers['HTTP_ACCEPT'] = "application/json"
      request.headers['X-API-Token'] = "boy-is-this-fake"
    end
    
    
    it "should return JSON" do
      get :index
      expect(response.content_type).to eq "application/json"
    end
    
    it "should return a 400 if the X-API-Token header is missing" do
      request.headers['X-API-Token'] = nil
      get :index
      expect(response.status).to eq 400
      expect(response.content_type).to eq "application/json"
    end
    
    it "should return a 400 if the authentication represented by the X-API-Token can't be found" do
      request.headers['X-API-Token'] = 'unknown, matey'
      allow(Api).to receive(:permitted?).and_return(double(:status => 400, :body => {:_api_error => []}))
      get :index
      expect(response.status).to eq 400
      expect(response.content_type).to eq "application/json"
    end
    
    it "should return a 403 if the X-API-Token doesn't yield GET authorisation for Texts" do
      allow(Api).to receive(:permitted?).and_return(double(:status => 403, :body => {:_api_error => []}))
      get :index
      expect(response.status).to eq 403
      expect(response.content_type).to eq "application/json"
    end
        
    it "should return a 200 when successful" do
      get :index
      expect(response.status).to eq 200
      expect(response).to render_template(partial: "_text", count: 3)
    end

    it "should return a collection" do
      get :index
      expect(response.status).to eq 200
      wrapper = JSON.parse(response.body)
      expect(wrapper).to be_a Hash
      resource = wrapper['_collection']
      expect(resource).to be_a Hash
      coll = resource['resources']
      expect(coll).to be_an Array
      expect(coll.count).to eq 3
      n = resource['count']
      expect(n).to eq 3
    end


    it "should set @auth_api_user_id if successful" do
      get :index
      expect(response.status).to eq 200
      expect(assigns(:auth_api_user_id)).to eq 123
    end

    it "should be public" do
      get :index
      expect(response.status).to eq 200
      expect(response.headers['Cache-Control']).to include "public"
    end
    
    it "should be cached in Varnish for a month" do
      get :index
      expect(response.status).to eq 200
      expect(response.headers['Cache-Control']).to include "s-maxage=2592000"
    end
    
  end
  
end
