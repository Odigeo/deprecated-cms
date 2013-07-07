require 'spec_helper'

describe TextsController do
  
  describe "INDEX" do
    
    before :each do
      Api.stub(:permitted?).and_return(double(:status => 200, 
                                               :body => {'authentication' => {'user_id' => 123}}))
      create :text
      create :text
      create :text
      request.headers['HTTP_ACCEPT'] = "application/json"
      request.headers['X-API-Token'] = "boy-is-this-fake"
    end
    
    
    it "should return JSON" do
      get :index
      response.content_type.should == "application/json"
    end
    
    it "should return a 400 if the X-API-Token header is missing" do
      request.headers['X-API-Token'] = nil
      get :index
      response.status.should == 400
      response.content_type.should == "application/json"
    end
    
    it "should return a 400 if the authentication represented by the X-API-Token can't be found" do
      request.headers['X-API-Token'] = 'unknown, matey'
      Api.stub(:permitted?).and_return(double(:status => 400, :body => {:_api_error => []}))
      get :index
      response.status.should == 400
      response.content_type.should == "application/json"
    end
    
    it "should return a 403 if the X-API-Token doesn't yield GET authorisation for Texts" do
      Api.stub(:permitted?).and_return(double(:status => 403, :body => {:_api_error => []}))
      get :index
      response.status.should == 403
      response.content_type.should == "application/json"
    end
        
    it "should return a 200 when successful" do
      get :index
      response.status.should == 200
    end

    it "should set @auth_api_user_id if successful" do
      get :index
      response.status.should == 200
      assigns(:auth_api_user_id).should == 123
    end


    it "should accept match and search parameters" do
      Text.should_receive(:index).with(anything, nil, 'ue').and_return([])
      get :index, app: 'foo', search: 'ue'
      response.status.should == 200
    end
    
    it "should accept a group parameter" do
      Text.should_receive(:index).with(anything, 'context', nil).and_return([])
      get :index, app: 'foo', group: :context
      response.status.should == 200
    end
    
  end
  
end
