require 'puppet/cloud_service'

Puppet::Face.define(:azure_cloud, '1.0.0') do

  summary 'View and manage Window Azure cloud services.'
  description <<-'EOT'
    This subcommand provides a command line interface to work with Windows Azure
    cloud services. The goal of these actions are to easily manage cloud services.
  EOT

end
