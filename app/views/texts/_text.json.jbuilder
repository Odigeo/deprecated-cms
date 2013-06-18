json.text do |json|
	json._links hyperlinks(self:    text_url(text),
	                       creator: api_user_url(text.created_by),
	                       updater: api_user_url(text.updated_by))
	json.(text, :app, :context, :name, :locale, :mime_type, :usage, :markdown, 
	            :result, :html, :lock_version)
	json.created_at text.created_at.utc.iso8601
	json.updated_at text.updated_at.utc.iso8601
end
