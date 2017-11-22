# ansible-playbook-wordpress

Sample Ansible playbook to install LEMP + Certbot + WordPress

**Work In Progress**

Tested with Ubuntu 16.04, 17.04, 17.10, Debian 8.9, 9.2; CentOS to follow.

## Variables

* certbot_email: email passed in --email parameter to certbot
* mysql_user: MySQL username for WordPress (wordpress)
* mysql_pass: MySQL password for WordPress (password)
* mysql_db: MySQL database for WordPress (wordpress)
* fpm_pm: FPM process manager (ondemand)
* fpm_max_children
* fpm_start_servers
* fpm_min_spare_servers
* fpm_max_spare_servers
* fpm_process_idle_timeout
* fpm_max_requests
* user_name: Linux/SFTP user for the blog (wordpress)
* user_pass: Temporary password for the user (password)
* wp_admin_name: WordPress Administrator
* wp_admin_email: WordPress Administrator's email
* wp_admin_pass: WordPress Administrator's password
* wp_domain: Site domain
* wp_title: WordPress site title (Just Another WordPress Site)
* wp_locale: WordPress locale (en_US)
* skip_ssl: Whether to use http or https
