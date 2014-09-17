require 'spec_helper'

describe TextsController, :type => :controller do
  
  describe "DELETE" do
    
    before :each do
      permit_with 200
      @text = create :text
      request.headers['HTTP_ACCEPT'] = "application/json"
      request.headers['X-API-Token'] = "so-totally-fake"
    end

    
    it "should return JSON" do
      delete :destroy, id: @text
      expect(response.content_type).to eq "application/json"
    end

    it "should return a 400 if the X-API-Token header is missing" do
      allow(Api).to receive(:permitted?).and_return(double(:status => 400, :body => {:_api_error => []}))
      request.headers['X-API-Token'] = nil
      delete :destroy, id: @text
      expect(response.status).to eq 400
    end
    
    it "should return a 400 if the authentication represented by the X-API-Token can't be found" do
      allow(Api).to receive(:permitted?).and_return(double(:status => 400, :body => {:_api_error => []}))
      request.headers['X-API-Token'] = 'unknown, matey'
      delete :destroy, id: @text
      expect(response.status).to eq 400
      expect(response.content_type).to eq "application/json"
    end

    it "should return a 403 if the X-API-Token doesn't yield DELETE authorisation for Texts" do
      allow(Api).to receive(:permitted?).and_return(double(:status => 403, :body => {:_api_error => []}))
      delete :destroy, id: @text
      expect(response.status).to eq 403
      expect(response.content_type).to eq "application/json"
    end
        
    it "should return a 204 when successful" do
      delete :destroy, id: @text
      expect(response.status).to eq 204
      expect(response.content_type).to eq "application/json"
    end

    it "should return a 404 when the Text can't be found" do
      delete :destroy, id: -1
      expect(response.status).to eq 404
    end
    
    it "should destroy the Text when successful" do
      delete :destroy, id: @text
      expect(response.status).to eq 204
      expect(Text.find_by_id(@text.id)).to be_nil
    end
    
  end
  
end
