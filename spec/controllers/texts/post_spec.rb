require 'spec_helper'

describe TextsController, :type => :controller do
  
  render_views
  
  describe "POST" do
    
    before :each do
      permit_with 200
      request.headers['HTTP_ACCEPT'] = "application/json"
      request.headers['X-API-Token'] = "incredibly-fake!"
      @args = {app: "the_app", context: "the_context", locale: "sv-SE", name: "the_name",
               mime_type: "mime/type"}
    end
    
    
    it "should return JSON" do
      post :create, @args
      expect(response.content_type).to eq "application/json"
    end
    
    it "should return a 400 if the X-API-Token header is missing" do
      request.headers['X-API-Token'] = nil
      post :create, @args
      expect(response.status).to eq 400
    end
    
    it "should return a 400 if the authentication represented by the X-API-Token can't be found" do
      request.headers['X-API-Token'] = 'unknown, matey'
      allow(Api).to receive(:permitted?).and_return(double(:status => 400, :body => {:_api_error => []}))
      post :create, @args
      expect(response.status).to eq 400
      expect(response.content_type).to eq "application/json"
    end

    it "should return a 403 if the X-API-Token doesn't yield POST authorisation for Texts" do
      allow(Api).to receive(:permitted?).and_return(double(:status => 403, :body => {:_api_error => []}))
      post :create, @args
      expect(response.status).to eq 403
      expect(response.content_type).to eq "application/json"
    end

    it "should return a 422 if the text already exists" do
      post :create, @args
      expect(response.status).to eq 201
      expect(response.content_type).to eq "application/json"
      post :create, @args
      expect(response.status).to eq 422
      expect(response.content_type).to eq "application/json"
      expect(JSON.parse(response.body)).to eq({"_api_error" => ["Resource not unique"]})
    end

    it "should return a 422 when there are validation errors" do
      post :create, @args.merge(:locale => "nix-DORF")
      expect(response.status).to eq 422
      expect(response.content_type).to eq "application/json"
      expect(JSON.parse(response.body)).to eq({"locale"=>["ISO language code format required ('de-AU')"]})
    end
                
    it "should return a 201 when successful" do
      post :create, @args
      expect(response.status).to eq 201
      expect(response).to render_template(partial: '_text', count: 1)
    end

    it "should render the object partial when successful" do
      post :create, @args
      expect(response).to render_template(partial: '_text', count: 1)
    end

    it "should contain a Location header when successful" do
      post :create, @args
      expect(response.headers['Location']).to be_a String
    end

    it "should return the new resource in the body when successful" do
      post :create, @args
      expect(response.body).to be_a String
    end
    
    it "should return converted markdown in the html attribute when appropriate" do
      post :create, @args.merge(markdown: true, result: "foo")
      j = JSON.parse(response.body)
      expect(j['text']['markdown']).to eq true
      expect(j['text']['html']).to eq "<p>foo</p>\n"
    end
    
  end
  
end
