#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
FROM tomcat:8.0-jre8
MAINTAINER Marco Lechner<mlechner@bfs.de>
#-------------Application Specific Stuff ----------------------------------------------------

ENV MFP_VERSION 3.12.1
ENV WEBAPP $CATALINA_HOME/webapps/bfs-printservice

RUN mkdir -p $WEBAPP
WORKDIR $WEBAPP

RUN wget -q https://repo1.maven.org/maven2/org/mapfish/print/print-servlet/$MFP_VERSION/print-servlet-$MFP_VERSION.war \
    -O print-servlet-$MFP_VERSION.war

RUN wget -q https://downloads.sourceforge.net/project/barcode4j/barcode4j/Barcode4J%202.1/barcode4j-2.1.0-bin.zip
RUN unzip -qj barcode4j-2.1.0-bin.zip barcode4j-2.1.0/build/barcode4j.jar \
        -d $CATALINA_HOME/lib/ && \
    rm barcode4j-2.1.0-bin.zip

ADD . $WEBAPP/print-apps
RUN rm -rf .git* Dockerfile LICENSE barcode4j.jar .travis.yml
RUN unzip -qn print-servlet-$MFP_VERSION.war && \
    rm print-servlet-$MFP_VERSION.war

ENV JAVA_OPTS="-Dfile.encoding=UTF-8 -Duser.timezone=UTC -Xmx512M -XX:MaxPermSize=256M"

CMD [ "catalina.sh", "run"]
