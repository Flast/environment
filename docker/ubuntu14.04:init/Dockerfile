from ubuntu:14.04
maintainer Kohei Takahashi <flast@flast.jp>
user root

run sed -i 's/archive.ubuntu.com/ftp.tsukuba.wide.ad.jp\/Linux/g' /etc/apt/sources.list ;\
    apt-get update ;\
    apt-get install -y openssh-client ;\
    apt-get autoclean

cmd /sbin/init

run ssh-keygen -N "" -t rsa     -f /etc/ssh/ssh_host_rsa_key ;\
    ssh-keygen -N "" -t dsa     -f /etc/ssh/ssh_host_dsa_key ;\
    ssh-keygen -N "" -t ecdsa   -f /etc/ssh/ssh_host_ecdsa_key ;\
    ssh-keygen -N "" -t ed25519 -f /etc/ssh/ssh_host_ed25519_key ;\
    install -d -m 700 -o root -g root /root/.ssh
