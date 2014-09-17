require "spec_helper"

describe DictionariesController, :type => :routing do
  describe "routing" do

    it "routes GET to #show" do
      expect(get("/v1/dictionaries/app/blahonga_checkout/locale/sv-SE")).to route_to(
        "dictionaries#show", app: "blahonga_checkout", locale: "sv-SE")
    end
    
    it "doesn't route POST" do
      expect(post("/v1/dictionaries/app/foo/locale/sv-SE")).not_to be_routable
    end

    it "doesn't route PUT" do
      expect(put("/v1/dictionaries/app/foo/locale/sv-SE")).not_to be_routable
    end

    it "doesn't route DELETE" do
      expect(delete("/v1/dictionaries/app/foo/locale/sv-SE")).not_to be_routable
    end

  end
end
