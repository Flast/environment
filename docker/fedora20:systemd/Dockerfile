from fedora:20
maintainer Kohei Takahashi <flast@flast.jp>
env container docker
user root

# Install python for ansible
run yum -y upgrade ;\
    yum -y install systemd openssh-server python ;\
    yum clean all

# workaround for systemd
# http://developerblog.redhat.com/2014/05/05/running-systemd-within-docker-container/
run (cd /lib/systemd/system/sysinit.target.wants/ ;\
     for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done) ;\
    rm -f /lib/systemd/system/multi-user.target.wants/* ;\
    rm -f /etc/systemd/system/*.wants/* ;\
    rm -f /lib/systemd/system/local-fs.target.wants/* ;\
    rm -f /lib/systemd/system/sockets.target.wants/*udev* ;\
    rm -f /lib/systemd/system/sockets.target.wants/*initctl* ;\
    rm -f /lib/systemd/system/basic.target.wants/* ;\
    rm -f /lib/systemd/system/anaconda.target.wants/*
volume /sys/fs/cgroup

cmd /usr/sbin/init

run ssh-keygen -N "" -t rsa   -f /etc/ssh/ssh_host_rsa_key ;\
    ssh-keygen -N "" -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key ;\
    install -d -o root -g root -m 700 /root/.ssh ;\
    systemctl enable sshd.service
