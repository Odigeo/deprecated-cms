class TextsController < ApplicationController

  ocean_resource_controller extra_actions: {},
                            required_attributes: [:lock_version, :app, :context, :name, :locale]

  respond_to :json
  
  before_action :find_text, :only => [:show, :update, :destroy]
  

 
  # GET /texts
  def index
    expires_in 0, 's-maxage' => 30.minutes
    if stale?(collection_etag(Text))
      api_render Text.collection(params)
    end
  end


  # GET /texts/1
  def show
    expires_in 0, 's-maxage' => 30.minutes
    if stale?(@text)
      api_render @text
    end
  end


  # POST /texts
  def create
    @text = Text.new(filtered_params(Text))
    set_updater(@text)
    if @text.valid?
      begin
        @text.save!
      rescue ActiveRecord::RecordNotUnique, ActiveRecord::StatementInvalid, 
             SQLite3::ConstraintException 
        render json: {_api_error: ["Text already exists"]}, :status => 422 
        return
      end
      api_render @text, new: true
    else
      render_validation_errors @text
    end
  end


  # PUT /texts/1
  def update
    if missing_attributes?
      render_api_error 422, "Missing resource attributes"
      return
    end
    begin
      @text.assign_attributes(filtered_params Text)
      set_updater(@text)
      @text.save
    rescue ActiveRecord::StaleObjectError
      render_api_error 409, "Stale Text"
      return
    end
    if @text.valid?
      api_render @text
    else
      render_validation_errors(@text)
    end
  end


  # DELETE /texts/1
  def destroy
    @text.destroy
    render_head_204
  end
  
  
  private
     
  def find_text
    @text = Text.find_by_id params[:id]
    return true if @text
    render_api_error 404, "Not found"
    false
  end
    
end
