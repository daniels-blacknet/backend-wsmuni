FROM node:8

# install JDK depend
COPY ./tools/jdk-8u221-linux-x64.tar.gz /opt
WORKDIR /opt
RUN tar xvfz /opt/jdk-8u221-linux-x64.tar.gz
RUN rm -f /opt/jdk-8u221-linux-x64.tar.gz
# Install Oracle Client DB 12.1
COPY ./tools/instantclient-*.zip /opt/
RUN unzip instantclient-basic-linux.x64-12.1.0.2.0.zip
RUN unzip instantclient-sqlplus-linux.x64-12.1.0.2.0.zip
RUN unzip instantclient-sdk-linux.x64-12.1.0.2.0.zip
RUN rm -f instantclient-*.zip
WORKDIR /opt/instantclient_12_1
RUN ln -s libclntshcore.so.12.1 libclntshcore.so
RUN ln -s libclntsh.so.12.1 libclntsh.so
RUN ln -s libocci.so.12.1 libocci.so

WORKDIR /app

# install SO dependencies
RUN apt-get update
RUN apt-get install libaio1

# Java JDK environment
ENV JAVA_HOME=/opt/jdk1.8.0_221
ENV JRE_HOME=${JAVA_HOME}/jre
ENV CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
ENV PATH=${JAVA_HOME}/bin:$PATH
#
# Oracle Instant Client environment
ENV LD_LIBRARY_PATH=/opt/instantclient_12_1
ENV OCI_INC_DIR=/opt/instantclient_12_1/sdk/include
ENV OCI_LIB_DIR=/opt/instantclient_12_1

# Bundle app source
COPY ./backend/ .

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY ./backend/package.json ./
RUN npm install
# If you are building your code for production
# RUN npm ci --only=production

EXPOSE 3000
CMD [ "node", "./bin/wsmuni" ]
###CMD [ "node" ]

