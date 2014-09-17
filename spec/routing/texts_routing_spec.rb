require "spec_helper"

describe TextsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(get("/v1/texts")).to route_to("texts#index")
    end

    it "routes to #show" do
      expect(get("/v1/texts/1")).to route_to("texts#show", :id => "1")
    end

    it "routes to #create" do
      expect(post("/v1/texts")).to route_to("texts#create")
    end

    it "routes to #update" do
      expect(put("/v1/texts/1")).to route_to("texts#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(delete("/v1/texts/1")).to route_to("texts#destroy", :id => "1")
    end

  end
end
