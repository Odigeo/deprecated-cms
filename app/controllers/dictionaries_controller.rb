class DictionariesController < ApplicationController

  ocean_resource_controller extra_actions: {},
                            required_attributes: []
  
  respond_to :json
  
    
  #
  # Returns all data within a specific context within an app (e.g., all error messages)
  #
  def show
    expires_in 0, 's-maxage' => 1.week
    if stale?(collection_etag(Text))
      dictionary = {}
      Text.where(app: params[:app], locale: params[:locale]).each do |t|
        dictionary[t.context] ||= {}
        dictionary[t.context][t.name] = t.markdown ? t.html : t.result
      end
      render json: dictionary, :status => 200
    end
  end
  
end
