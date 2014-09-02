
echo "* Install Jekyll"
gem install git RedCloth --no-rdoc --no-ri
gem install jekyll --pre --no-rdoc --no-ri
 
export LC_ALL=en_US.UTF-8 
export LANG=en_US.UTF-8

cd /jekyll

echo "* Setting up Apache2"

a2enmod rewrite
a2dissite default

echo '
<VirtualHost *:80>
        ServerAdmin webmaster@kodeklubben.no

        DocumentRoot /jekyll/_site

        DirectoryIndex index.html readme.html

        <Directory />
                Options FollowSymLinks
                AllowOverride None
        </Directory>

</VirtualHost>
' > /etc/apache2/sites-available/kodeklubben

a2ensite kodeklubben

service apache2 restart

echo "* Cleanup"
apt-get clean
apt-get autoclean