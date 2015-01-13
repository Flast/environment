FROM fedora:21
RUN useradd -m -d /home/flast flast

RUN yum -y upgrade ;\
    yum clean all

RUN yum -y install make \
      texlive texlive-ptex texlive-ptex-bin texlive-ptex2pdf texlive-ptex2pdf-bin ;\
    yum clean all

RUN yum -y texlive-japanese ;\
    yum clean all

USER flast
WORKDIR /home/flast
ENV HOME /home/flast
