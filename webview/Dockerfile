FROM jeanblanchard/busybox-java:7

MAINTAINER guenter.grossberger@ca.com

WORKDIR /opt/introscope-install

### For new Introscope version you must change the following variables
ENV INTROSCOPE_VERSION=10.2.0.27
### End for new Introscope version

ENV INTROSCOPE_HOME=/opt/CA/Introscope
ENV INTROSCOPE_BIN=introscope${INTROSCOPE_VERSION}otherUnix.jar

ENV EM_HOST=em
ENV EM_PORT=5001
ENV EM_WEB_PORT=8081

ENV HEAP_XMX **DEFAULT**

COPY ${INTROSCOPE_BIN} /opt/introscope-install/${INTROSCOPE_BIN}
COPY eula-introscope/ca-eula.txt /opt/introscope-install/eula-introscope/ca-eula.txt
COPY startup.sh /opt/introscope-install/startup.sh
COPY SampleResponseFile.Introscope.txt /opt/introscope-install/SampleResponseFile.Introscope.txt
#COPY addons /opt/introscope-install/addons

# run the installation of WebView
RUN java -Xmx2048m -jar ${INTROSCOPE_BIN} -f SampleResponseFile.Introscope.txt && \
    chmod +x startup.sh

WORKDIR ${INTROSCOPE_HOME}

# Port on which WebView will listen for HTTP connections.
EXPOSE 8080

CMD /opt/introscope-install/startup.sh
