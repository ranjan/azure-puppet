module Puppet
  module ApplicationConfig

    def initialize_env_variable(options)
      ENV['azure_management_certificate'.upcase] = options[:management_certificate]
      ENV['azure_subscription_id'.upcase] = options[:azure_subscription_id]
      ENV['azure_management_endpoint'.upcase] = options[:management_endpoint]
      require 'azure'
    end

    def add_default_options(action)
      add_management_certificate_option(action)
      add_subscription_id_option(action)
      add_management_endpoint_option(action)
    end
      
    def merge_default_options(options)
      default_options = { "management-certificate" => true, "subscription-id" => true, "management-endpoint" => true }
      default_options.merge(options)
    end

    def add_management_certificate_option(action)
      action.option '--management-certificate=' do
        summary 'The subscription identifier for the Windows Azure portal.'
        description <<-EOT
          The subscription identifier for the Windows Azure portal.
        EOT
        required
        before_action do |action, args, options|
          if options[:management_certificate].empty?
            raise ArgumentError, "Management certificate file is required"
          end
          unless test 'f', options[:management_certificate]
            raise ArgumentError, "Could not find file '#{options[:management_certificate]}'"
          end
          unless test 'r', options[:management_certificate]
            raise ArgumentError, "Could not read from file '#{options[:management_certificate]}'"
          end
          unless(options[:management_certificate] =~ /(pem|pfx)$/)
            raise RuntimeError, "Management certificate expects a .pem or .pfx file."
          end
        end
      end
    end

    def add_subscription_id_option(action)
      action.option '--azure-subscription-id=' do
        summary 'The subscription identifier for the Windows Azure portal.'
        description <<-EOT
          The subscription identifier for the Windows Azure portal.
        EOT
        required
        before_action do |action, args, options|
          if options[:azure_subscription_id].empty?
            raise ArgumentError, "Subscription id is required."
          end
        end
      end
    end

    def add_management_endpoint_option(action)
      action.option '--management-endpoint=' do
        summary 'The management endpoint for the Windows Azure portal.'
        description <<-EOT
          The management endpoint for the Windows Azure portal.
        EOT
        
      end
    end

    def add_location_option(action)
      action.option '--location=' do
        summary "The location identifier for the Windows Azure portal."
        description <<-EOT
          The location identifier for the Windows Azure portal.
          valid choices are ('West US', 'East US', 'East Asia', 'Southeast Asia',
          'North Europe', 'West Europe' ...).
        EOT
        required
        before_action do |action, args, options|
          if options[:location].empty?
            raise ArgumentError, "Location is required"
          end
        end
      end
    end

    def add_affinity_group_name_option(action)
      action.option '--affinity-group-name=' do
        summary "The affinity group name."
        description <<-EOT
          The affinity group name.
        EOT
        required
        before_action do |action, args, options|
          if options[:affinity_group_name].empty?
            raise ArgumentError, "Affinity group name is required"
          end
        end
      end
    end

    
  end
end
