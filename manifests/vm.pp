define windowsazure::vm (
  $vm_name,
  $vm_user,
  $image,
  $location,
  $homedir = undef,
  $azure_management_certificate,
  $azure_subscription_id,
  $vm_size = 'Small',
  $puppet_master_ip = undef,
  $private_key_file = undef,
  $certificate_file = undef ,
  $storage_account_name = undef,
  $cloud_service_name = undef,
  $password = undef
) {

    Exec { path => ['/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/'] }

    $cmd = "puppet azure_vm create --vm-user $vm_user --management-certificate $azure_management_certificate --azure-subscription-id $azure_subscription_id --image $image --vm-name $vm_name --location '$location'"

    if $vm_name == undef {
      fail('No vm_name specified for provisioning VM.')
    }

    if $vm_user == undef {
      fail('No vm_user specified for provisioning VM.')
    }

    if $image == undef {
      fail('No image specified for provisioning VM.')
    }

    if $location == undef {
      fail('No location specified for provisioning VM.')
    }

    if ($homedir == undef) and ($puppet_master_ip != undef) {
      fail('Specify home directory path.')
    }elsif ($homedir != undef){
      $export_home_dir = "export HOME=$homedir; "
    }

    if $azure_management_certificate == undef {
      fail('Specify azure management certificate path.')
    }

    if $azure_subscription_id == undef {
      fail('Specify subscription id.')
    }

    if $puppet_master_ip != undef {
      $pmi = "--puppet-master-ip $puppet_master_ip"
    }

    if $password != undef {
      $passwd = "--password $password"
    }

    if $storage_account_name != undef {
      $san = " --storage-account-name $storage_account_name"
    }

    if $certificate_file != undef {
      $crtf = "--certificate-file $certificate_file"
    }

    if $private_key_file != undef {
      $pkf = "--private-key-file $private_key_file"
    }

    if $cloud_service_name != undef {
      $csn = "--cloud-service-name $cloud_service_name"
    }

    $puppet_command = "$export_home_dir $cmd $pmi $passwd $san $crtf $pkf $csn"

    if !defined( Package['azure'] ) {
      package { 'azure':
        ensure   => '0.6.0',
        provider => 'gem',
      }
    }

    exec {"Provisioning VM ${title}":
      command    => "/bin/bash -c \"$puppet_command\"",
      logoutput  => true
    }

}
