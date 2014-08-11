from ubuntu:14.04
maintainer Kohei Takahashi <flast@flast.jp>
user root

# Install python for ansible
run sed -i 's/archive.ubuntu.com/ftp.tsukuba.wide.ad.jp\/Linux/g' /etc/apt/sources.list ;\
    apt-get update ;\
    apt-get upgrade -y ;\
    apt-get install -y python3 openssh-server ;\
    apt-get autoclean

cmd /sbin/init

# /etc/ssh/ssh_host_*_key are automaticaly generated in first execution (apt-get will do)
run install -d -m 700 -o root -g root /root/.ssh ;\
    update-rc.d ssh defaults
