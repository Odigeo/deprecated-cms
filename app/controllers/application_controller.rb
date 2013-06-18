class ApplicationController < ActionController::Base

  include OceanApplicationController

  before_filter :require_x_api_token
  before_filter :authorize_action


  #
  # Authorization
  #
  def authorize_action
    return true if ENV['NO_SOA_AUTH']
    # Obtain any nonstandard actions
    @@extra_actions[controller_name] ||= begin
      extra_actions
    rescue NameError => e
      {}
    end
    # Create a query string and call Auth
    app = params[:app_id] || params[:app] || params[:id] || '*'      # Obsolete?
    qs = Api.authorization_string(@@extra_actions, controller_name, action_name, app)
    response = Api.permitted?(@x_api_token, query: qs)                                   
    if response.status == 200
      @auth_api_user_id = response.body['authentication']['user_id']
      return true
    end
    error_messages = response.body['_api_error']
    render_api_error response.status, *error_messages
    false
  end
      
end
