#!/bin/bash
# sudo yum update -y
# sudo amazon-linux-extras install -y php8.0
# sudo yum install -y httpd
# sudo systemctl start httpd
# sudo systemctl enable httpd
# sudo usermod -a -G apache ec2-user
# sudo chown -R ec2-user:apache /var/www
# sudo chmod 2775 /var/www
# find /var/www -type d -exec sudo chmod 2775 {} \;
# find /var/www -type f -exec sudo chmod 0664 {} \;

# echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/index.php

# sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
# sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
# sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=1

# sudo apt update
# sudo apt install -y libapache2-mod-php8.1

echo "<?php phpinfo(); ?>" | sudo tee /opt/bitnami/apache/htdocs/index.php