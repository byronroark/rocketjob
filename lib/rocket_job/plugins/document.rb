# encoding: UTF-8
require 'active_support/concern'
require 'mongo'
require 'mongo_ha'
begin
  require 'active_model/serializers/xml'
rescue LoadError
  raise "Please add gem 'activemodel-serializers-xml' to Gemfile to support Active Model V5"
end
require 'mongo_mapper'

module RocketJob
  module Plugins
    # Base class for storing models in MongoDB
    module Document
      extend ActiveSupport::Concern
      include MongoMapper::Document

      included do
        # Prevent data in MongoDB from re-defining the model behavior.
        self.static_keys     = true

        # Only save changes to this instance to prevent losing
        # changes made by other processes or threads.
        self.partial_updates = true

        # Turn off embedded callbacks. Slow and not used by Jobs.
        embedded_callbacks_off
      end

      # Patch the way MongoMapper reloads a model
      def reload
        if doc = collection.find_one(:_id => id)
          # Clear out keys that are not returned during the reload from MongoDB
          (keys.keys - doc.keys).each { |key| send("#{key}=", nil) }
          initialize_default_values
          load_from_database(doc)
          self
        else
          raise MongoMapper::DocumentNotFound, "Document match #{_id.inspect} does not exist in #{collection.name} collection"
        end
      end

      private

      def update_attributes_and_reload(attrs)
        if doc = collection.find_and_modify(query: {:_id => id}, update: {'$set' => attrs})
          # Clear out keys that are not returned during the reload from MongoDB
          (keys.keys - doc.keys).each { |key| send("#{key}=", nil) }
          initialize_default_values
          load_from_database(doc)
          self
        else
          raise MongoMapper::DocumentNotFound, "Document match #{_id.inspect} does not exist in #{collection.name} collection"
        end
      end

    end
  end
end
