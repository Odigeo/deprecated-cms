#
# The path /alive is implemented solely for the benefit of Varnish,
# which is set up to use it for health checking. Due to the routing
# implemented in Varnish, /alive can never be reached from the outside.
#

class AliveController < ApplicationController
  
  skip_before_action :require_x_api_token
  skip_before_action :authorize_action
  
  
  def index
    # Make a call to the DB to make sure it's operational
    Text.count 
    # All ok
    render :text => "ALIVE", :status => 200
    logger.info "ALIVE"
  end
  
end
