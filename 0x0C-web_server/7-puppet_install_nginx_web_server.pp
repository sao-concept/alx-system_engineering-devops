# To install & configure nginx on a server using Puppet

$config = "
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html;

    location /redirect_me {
        return 301 https://www.youtube.com/watch?v=QH2-TGUlwu4;
    }
}
"

# Install Nginx package
package { 'nginx':
  ensure => 'installed',
}

# Create 'index.html' file
file { '/var/www/html/index.html':
  ensure  => 'present',
  content => 'Hello World!',
  mode    => '0644',
}

# Configure Nginx
file { '/etc/nginx/sites-available/default':
  ensure  => 'present',
  content => $config,
}

# Restart Nginx service
exec { 'service nginx restart':
  path => ['/usr/sbin', '/usr/bin'],
}
