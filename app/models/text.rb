# == Schema Information
#
# Table name: texts
#
#  id           :integer          not null, primary key
#  app          :string(100)
#  locale       :string(10)
#  context      :string(100)
#  name         :string(100)
#  mime_type    :string(100)
#  usage        :string(100)      default("")
#  result       :text
#  lock_version :integer          default(0), not null
#  created_at   :datetime
#  updated_at   :datetime
#  markdown     :boolean          default(FALSE), not null
#  html         :text
#  created_by   :integer
#  updated_by   :integer
#
# Indexes
#
#  index_texts_on_app_and_context_and_locale_and_updated_at  (app,context,locale,updated_at)
#  index_texts_on_app_and_locale_and_updated_at              (app,locale,updated_at)
#  index_texts_on_created_at                                 (created_at)
#  index_texts_on_updated_at                                 (updated_at)
#  main_index                                                (app,context,locale,name) UNIQUE
#

class Text < ActiveRecord::Base

  ocean_resource_model index:  [:app, :context, :name, :locale, :created_at],
                       ranged: [:created_at],
                       search: :result,
                       invalidate_member: INVALIDATE_MEMBER_DEFAULT +
                                          [ lambda { |m| "dictionaries/app/#{m.app}/locale/#{m.locale}($|\\?)" } ]

  default_scope -> { order "updated_at ASC" }

  attr_accessible :app, :context, :locale, :name, :mime_type, :result, :lock_version, :usage, 
                  :markdown, :html
  
  validates :app,     :presence => true,
                      :format => { :with => /\A[A-Za-z0-9_-]+\z/ }
  
  validates :context, :presence => true,
                      :format => { :with => /\A[A-Za-z0-9_-]+\z/ }
  
  validates :locale,  :presence => true,
                      :format => { :with => /\A[a-z]{2}\-[A-Z]{2}\z/,
                                   :message => "ISO language code format required ('de-AU')" 
                                 }
                                 
  validates :name,    :presence => true,
                      :format => { :with => /\A[A-Za-z0-9._-]+\z/,
                                   :message => "may only contain alphanumeric characters, periods, underscores and hyphens"
                                 }
                                 
  validates :mime_type, :presence => true,
                        :format => { :with => /\//, :message => "must contain a slash" }
                        
  validates :lock_version, :presence => true
  validates :created_by,   :presence => true
  validates :updated_by,   :presence => true


  before_validation :process_markdown


  def process_markdown
    self.html = nil
    self.html = Kramdown::Document.new(result).to_html if markdown
    true
  end
  
  
  def self.a_to_nested_hash(arr)
    res = {}
    arr.each do |t|
      res[t.name] ||= {}
      res[t.name][t.locale] = t
    end
    res
  end

end
