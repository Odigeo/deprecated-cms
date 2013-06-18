class TextObserver < ActiveRecord::Observer
 
  def after_create(model)
    v = model.class.latest_api_version
  	# puts "Created #{model.inspect}"
    Api.ban "/#{v}/texts"
    Api.ban "/#{v}/dictionaries/app/#{model.app}/locale/#{model.locale}"
  end


  def after_update(model)
    v = model.class.latest_api_version
    # puts "Updated #{model.inspect}"
    Api.ban "/#{v}/texts/#{model.id}"
    Api.ban "/#{v}/texts/#{model.id}/", true
    Api.ban "/#{v}/texts"
    Api.ban "/#{v}/dictionaries/app/#{model.app}/locale/#{model.locale}"
  end


  def after_touch(model)
    after_update(model)
  end


  def after_destroy(model)
    v = model.class.latest_api_version
    # puts "Destroyed #{model.inspect}"
    Api.ban "/#{v}/texts/#{model.id}"
    Api.ban "/#{v}/texts/#{model.id}/", true
    Api.ban "/#{v}/texts"
    Api.ban "/#{v}/dictionaries/app/#{model.app}/locale/#{model.locale}"
  end

end
