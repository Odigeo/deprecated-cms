require "spec_helper"

describe TextsController do
  describe "routing" do

    it "routes to #index" do
      get("/v1/texts").should route_to("texts#index")
    end

    it "routes to #show" do
      get("/v1/texts/1").should route_to("texts#show", :id => "1")
    end

    it "routes to #create" do
      post("/v1/texts").should route_to("texts#create")
    end

    it "routes to #update" do
      put("/v1/texts/1").should route_to("texts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/v1/texts/1").should route_to("texts#destroy", :id => "1")
    end

  end
end
