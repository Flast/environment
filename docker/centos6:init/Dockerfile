from centos:centos6
maintainer Kohei Takahashi <flast@flast.jp>
user root

# Install python for ansible
run yum -y upgrade ;\
    yum -y install python openssh-server ;\
    yum clean all

cmd /sbin/init

run ssh-keygen -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key ;\
    install -d -m 700 -o root -g root /root/.ssh ;\
    chkconfig sshd on
