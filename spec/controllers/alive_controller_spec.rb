require 'spec_helper'

describe AliveController do

  it "GET /alive should return a 200 with a body of ALIVE" do
    get :index
    response.status.should be(200)
    response.body.should == "ALIVE"
  end
  
end
