module Ocean
  module OceanResourceModel
    
    extend ActiveSupport::Concern

    included do
      # Inheritable invalidation callbacks
      after_create  { |model| model.class.invalidate }
      after_update  { |model| model.invalidate }
      after_touch   { |model| model.invalidate }
      after_destroy { |model| model.invalidate }
    end


    module ClassMethods

      #
      # Declare the class as an Ocean Resource, include necessary
      # modules and define what attributes can be indexed and searched.
      #
      def ocean_resource_model(index:  [:name], 
      	                       search: :description,
                               invalidate_member:     ['/', '$', '?'],
                               invalidate_collection: ['$', '?']
      	                      )
      	include ApiResource
      	cattr_accessor :index_only
      	cattr_accessor :index_search_property
        cattr_accessor :varnish_invalidate_member
        cattr_accessor :varnish_invalidate_collection
      	self.index_only = index
      	self.index_search_property = search
        self.varnish_invalidate_member = invalidate_member
        self.varnish_invalidate_collection = invalidate_collection
      end
    end
  end
end


ActiveRecord::Base.send :include, Ocean::OceanResourceModel
