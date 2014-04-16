# Class: bacula
#
#
class bacula(
    $bacula_client           = hiera('bacula::bacula_client'),
    $bacula_server           = hiera('bacula::bacula_server'),
    $domaine                 = hiera('bacula::domaine'),
    $bacula_password_fd      = hiera('bacula::bacula_password_fd'),
    $bacula_password_sd      = hiera('bacula::bacula_password_sd'),
    $bacula_db_name_dir      = hiera('bacula::bacula_db_name_dir'),
    $bacula_db_user_dir      = hiera('bacula::bacula_db_user_dir'),
    $bacula_password_dir     = hiera('bacula::bacula_password_dir'),
    $mysql_new_root_password = hiera('bacula::mysql_new_root_password'),
    $bacula_db_password_dir  = hiera('bacula::bacula_db_password_dir')){

    if $bacula_server == 'enable' {
        file { '/var/preseed/bacula-director-mysql.preseed':
            ensure  => file,
            owner   => 'root',
            group   => 'root',
            mode    => '0770',
            content => template("bacula/bacula-director-mysql.preseed.erb"),
        }

        package { 'bacula-director-mysql':
            ensure       => installed,
            responsefile => '/var/preseed/bacula-director-mysql.preseed',
        }

        file { '/etc/bacula/clients/dummy.conf':
            ensure  => file,
            content => "#dummy",
        }

        file { '/etc/bacula/bacula-dir.conf':
            notify  => service['bacula-director'],
            ensure  => file,
            require => Package['bacula-director-mysql'],
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => template('bacula/bacula-dir.conf.erb'),
        }

        file { '/etc/bacula/clients':
            ensure => "directory",
            owner  => "bacula",
            group  => "bacula",
            mode   => '0770',
        }

        package { 'bacula-console':
            ensure => installed,
        }
        
        file { '/etc/bacula/bconsole.conf':
            ensure  => file,
            require => Package['bacula-console'],
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => template('bacula/bconsole.conf.erb'),
        }
        
        service{ 'bacula-director':
            ensure  => running,
            enable  => true,
        }

        File <<| tag == "bacula-client"  |>>

        File['/var/preseed/bacula-director-mysql.preseed'] ->
        Package['bacula-director-mysql'] ->
        File['/etc/bacula/bacula-dir.conf'] ->
        File['/etc/bacula/clients'] ->
        File['/etc/bacula/clients/dummy.conf'] ->
        Package['bacula-console'] ->
        File['/etc/bacula/bconsole.conf']

    } else {
        package { 'bacula-director-mysql':
            ensure => purged,
        }

        package { 'bacula-console':
            ensure => purged,
        }
    }

    if $bacula_client == 'enable' {
        service{"bacula-sd":
            ensure  => running,
            enable  => true,
            require => Package["bacula-sd"],
        }

        service{"bacula-fd":
            ensure  => running,
            enable  => true,
            require => Package["bacula-fd"],
        }

        package { 'bacula-sd':
            ensure => installed,
        }

        package { 'bacula-fd':
            ensure => installed,
        }
        
        file { "/etc/bacula/bacula-fd.conf":
            notify  => service["bacula-fd"],
            ensure  => file,
            require => Package['bacula-fd'],
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => template("bacula/bacula-fd.conf.erb"),
        }

        file { "/etc/bacula/bacula-sd.conf":
            notify  => service["bacula-sd"],
            ensure  => file,
            require => Package['bacula-sd'],
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => template("bacula/bacula-sd.conf.erb"),
        }

        file { [ "/var/restore" ]:
            ensure => "directory",
            owner  => bacula,
            group  => bacula,
            mode   => '0770',
        }

        @@file { "/etc/bacula/clients/$domaine":
            notify  => service["bacula-director"],
            ensure  => file,
            require => Package['bacula-director-mysql'],
            owner   => bacula,
            group   => bacula,
            mode    => '0644',
            content => template("bacula/domaine.erb"), 
            path    => "/etc/bacula/clients/$domaine",
            tag     => 'bacula-client',
        }
    } else {
        package { 'bacula-sd':
            ensure => purged,
        }

        package { 'bacula-fd':
            ensure => purged,
        }
    }
}

