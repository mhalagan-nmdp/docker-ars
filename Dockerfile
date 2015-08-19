FROM ubuntu:14.04
MAINTAINER Mike Halagan <mhalagan@nmdp.org>

RUN PERL_MM_USE_DEFAULT=1 apt-get update -q \
    && apt-get dist-upgrade -qy \
    && apt-get install -qyy openjdk-7-jre-headless perl-doc wget curl build-essential git \
    && cpan YAML Getopt::Long Data::Dumper LWP::UserAgent Test::More Dancer \
    && cd /opt && git clone https://github.com/nmdp-bioinformatics/service-ars \
    && cd service-ars/ARS_App && perl Makefile.PL \
    && make && make test && make install 

VOLUME /opt/service-ars

EXPOSE 8080
EXPOSE 8081

WORKDIR /var/opt/service-ars
CMD plackup -D -E deployment -s Starman --workers=10 -p 8080 -a ARS_App/bin/app.pl

