FactoryGirl.define do
  factory :text do
    app       { "app_#{rand(10000)}" }
    context   { "context_#{rand(10000)}" }
    locale    "sv-SE"
    name      { "name_#{rand(10000)}" }
    mime_type "text/plain"
    lock_version 0
    usage     ""
    result    "Moxie"
    created_by { rand 10000 }
    updated_by { rand 10000 }
  end
end