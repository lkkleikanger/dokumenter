# http://patorjk.com/software/taag/#p=display&f=Graffiti&t=Kodeklubben
echo '
 ____  __.         .___      __   .__       ___.  ___.                  
|    |/ _|____   __| _/____ |  | _|  |  __ _\_ |__\_ |__   ____   ____  
|      < /  _ \ / __ |/ __ \|  |/ /  | |  |  \ __ \| __ \_/ __ \ /    \ 
|    |  (  <_> ) /_/ \  ___/|    <|  |_|  |  / \_\ \ \_\ \  ___/|   |  \
|____|__ \____/\____ |\___  >__|_ \____/____/|___  /___  /\___  >___|  /
        \/          \/    \/     \/              \/    \/     \/     \/ '

echo "* Localize sources"
sed -i 's/us./no./g' /etc/apt/sources.list

echo "* Upgrade system" 
apt-mark hold grub-common grub-pc grub-pc-bin grub2-common
aptitude hold grub-common grub-pc grub-pc-bin grub2-common

apt-get update 
apt-get upgrade -y 
apt-get install -y --force-yes build-essential python-pygments apache2 git curl nodejs