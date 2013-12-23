require 'tilt'

Puppet::Face.define :azure_sqldb, '1.0.0' do
  action :list do

    summary 'List SQL database servers.'
    arguments 'list'
    description <<-'EOT'
      The list action obtains a list of sql database servers and
      displays them on the console output.
    EOT

    Puppet::SqlDatabase.add_default_options(self)

    when_invoked do |options|
      Puppet::SqlDatabase.initialize_env_variable(options)
      db_server = Azure::SqlDatabaseManagementService.new

      servers = db_server.list_servers
      template = Tilt.new(Puppet::SqlDatabase.views('servers.erb'))
      template.render(nil, db_servers:  servers)
    end

    returns 'Array of database server objets.'

    examples <<-'EOT'
      $ puppet azure_sqldb list --management-certificate path-to-azure-certificate \
        --azure-subscription-id=YOUR-SUBSCRIPTION-ID --management-endpoint=https://management.database.windows.net:8443/

    Listing Servers

      Server: 1
        Server Name         : esinlp9bav
        Administrator login : puppet3
        Location            : West US

      Server: 2
        Server Name         : estkonosnv
        Administrator login : puppet
        Location            : West US

      Server: 3
        Server Name         : ezprthvj9w
        Administrator login : puppet
        Location            : West US

    EOT
  end
end
