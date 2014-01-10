require 'puppet/application_config'
require 'puppet/core/utility'
include Puppet::ApplicationConfig

module Puppet::VirtualNetwork
  class << self
    def views(name)
      File.join(File.dirname(__FILE__), 'face/azure_cloud/views', name)
    end

    def add_create_options(action)
      add_default_options(action)
      add_affinity_group_name_option(action)
      add_location_option(action)
      add_description_option(action)
      add_label_option(action)
      add_extended_properties_option(action)
    end

    def add_description_option(action)
      action.option '--description=' do
        summary "Description of affinity group"
        description <<-EOT
          Description of affinity group.
        EOT
      end
    end

    def add_extended_properties_option(action)
      action.option '--extended-properties=' do
        summary "Description of affinity group"
        description <<-EOT
          Description of affinity group.
        EOT
      end
    end

    def add_label_option(action)
      action.option '--label=' do
        summary "Label of affinity group"
        description <<-EOT
          Label of affinity group.
        EOT
        required
        before_action do |action, args, options|
          if options[:label].empty?
            raise ArgumentError, "Label is required"
          end
        end
      end
    end

  end
end
