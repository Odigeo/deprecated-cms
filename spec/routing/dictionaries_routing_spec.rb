require "spec_helper"

describe DictionariesController do
  describe "routing" do

    it "routes GET to #show" do
      get("/v1/dictionaries/app/blahonga_checkout/locale/sv-SE").should route_to(
        "dictionaries#show", app: "blahonga_checkout", locale: "sv-SE")
    end
    
    it "doesn't route POST" do
      post("/v1/dictionaries/app/foo/locale/sv-SE").should_not be_routable
    end

    it "doesn't route PUT" do
      put("/v1/dictionaries/app/foo/locale/sv-SE").should_not be_routable
    end

    it "doesn't route DELETE" do
      delete("/v1/dictionaries/app/foo/locale/sv-SE").should_not be_routable
    end

  end
end
