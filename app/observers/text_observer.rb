class TextObserver < ActiveRecord::Observer
 
  def after_create(model)
    v = model.class.latest_api_version
    Api.ban "/#{v}/texts"
    Api.ban "/#{v}/dictionaries/app/#{model.app}/locale/#{model.locale}"
  end


  def after_update(model)
    v = model.class.latest_api_version
    Api.ban "/#{v}/texts/#{model.id}"
    Api.ban "/#{v}/texts/#{model.id}/", true
    Api.ban "/#{v}/texts"
    Api.ban "/#{v}/dictionaries/app/#{model.app}/locale/#{model.locale}"
  end


  def after_touch(model)
    after_update(model)
  end


  def after_destroy(model)
    after_update(model)
  end

end
