Postmortem Analysis

Following the launch of ALX's System Engineering & DevOps project 0x19 at approximately 06:00 West African Time (WAT) in Nigeria, an outage occurred on an isolated Ubuntu 14.04 container running an Apache web server. GET requests on the server resulted in 500 Internal Server Errors, contrary to the expected response of an HTML file defining a simple Holberton WordPress site.

Debugging Process

The bug debugger, Bamidele (Lexxyla), identified the issue around 19:20 PST and initiated the troubleshooting process. The investigation involved checking running processes using ps aux, confirming that two apache2 processes (root and www-data) were functioning correctly. Further examination in the sites-available folder of the /etc/apache2/ directory revealed that the web server was serving content from /var/www/html/.

An attempt to trace the root Apache process using strace yielded no useful information. However, repeating the process on the www-data process exposed an -1 ENOENT (No such file or directory) error when attempting to access the file /var/www/html/wp-includes/class-wp-locale.phpp.

Upon inspecting the files in the /var/www/html/ directory using Vim pattern matching, the erroneous .phpp file extension was identified in the wp-settings.php file (Line 137: require_once( ABSPATH . WPINC . '/class-wp-locale.php' );). The issue was resolved by removing the trailing 'p' from the file extension.

A subsequent curl test on the server returned a 200 A-ok! Following this, a Puppet manifest (0-strace_is_your_friend.pp) was crafted to automate the correction of similar errors in the future.

Summation

In summary, the root cause of the outage was a typographical error. Specifically, the WordPress app encountered a critical error in wp-settings.php when attempting to load the file class-wp-locale.phpp. The correct file name, situated in the wp-content directory of the application folder, was class-wp-locale.php. The patch involved a simple correction of the typo by removing the trailing 'p.'

Prevention

It's crucial to note that this outage was an application error, not a web server error. To prevent such incidents in the future, the following precautions are recommended:

Thorough Testing: Prior to deployment, thoroughly test the application to identify and address potential errors early on.

Status Monitoring: Implement a reliable uptime-monitoring service, such as UptimeRobot, to receive instant alerts in case of website outages.

Additionally, in response to this error, a Puppet manifest (0-strace_is_your_friend.pp) was developed to automatically fix similar errors in the file /var/www/html/wp-settings.php by replacing any phpp extensions with php. While this proactive measure is in place, it's important to maintain a vigilant testing and monitoring approach to prevent future incidents. After all, even programmers can occasionally encounter typo errors.
