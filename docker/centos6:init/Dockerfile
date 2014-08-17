from centos:centos6
maintainer Kohei Takahashi <flast@flast.jp>
user root

run yum -y install openssh ;\
    yum clean all

cmd /sbin/init

run ssh-keygen -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key ;\
    ssh-keygen -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key ;\
    install -d -m 700 -o root -g root /root/.ssh

onbuild run yum -y upgrade ;\
            yum -y install openssh-server ;\
            yum clean all ;\
            chkconf sshd on
onbuild add authorized_keys /root/.ssh/authorized_keys
