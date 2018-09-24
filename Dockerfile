#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
FROM tomcat:8.0-jre8
MAINTAINER Marco Lechner<mlechner@bfs.de>
#-------------Application Specific Stuff ----------------------------------------------------

RUN mkdir -p /usr/local/tomcat/webapps/bfs-printservice
RUN wget http://repo1.maven.org/maven2/org/mapfish/print/print-servlet/3.12.1/print-servlet-3.12.1.war
RUN cp print-servlet-*.war /usr/local/tomcat/webapps/bfs-printservice && rm print-servlet-*.war
WORKDIR /usr/local/tomcat/webapps/bfs-printservice
RUN unzip print-servlet-3.12.1.war && rm print-servlet-3.12.1.war
RUN rm -Rf /usr/local/tomcat/webapps/bfs-printservice/print-apps && mkdir /usr/local/tomcat/webapps/bfs-printservice/print-apps
ADD . /usr/local/tomcat/webapps/bfs-printservice/print-apps
RUN wget https://downloads.sourceforge.net/project/barcode4j/barcode4j/Barcode4J%202.1/barcode4j-2.1.0-bin.zip -O barcode4j.jar
RUN cp barcode4j.jar /usr/local/tomcat/lib
RUN rm -rf .git* Dockerfile LICENSE barcode4j.jar .travis.yml

ENV JAVA_OPTS="-Dfile.encoding=UTF-8 -Duser.timezone=UTC -Xmx512M -XX:MaxPermSize=256M"

CMD [ "catalina.sh", "run"]
