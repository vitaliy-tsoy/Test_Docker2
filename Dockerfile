FROM ubuntu:16.04
RUN apt update && apt install -y \
    default-jdk \
    maven \
    git \
    curl
WORKDIR /opt/tomcat/
RUN groupadd tomcat
RUN useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
RUN curl -O https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.73/bin/apache-tomcat-8.5.73.tar.gz
RUN tar xvzf apache-tomcat-8.5.73.tar.gz -C /opt/tomcat --strip-components=1
RUN chgrp -R tomcat /opt/tomcat
RUN chmod -R g+r conf
RUN chmod g+x conf
RUN chown -R tomcat webapps/ work/ temp/ logs/
WORKDIR /home/boxfuse/
RUN git clone https://github.com/boxfuse/boxfuse-sample-java-war-hello.git
WORKDIR boxfuse-sample-java-war-hello/
RUN mvn package
WORKDIR target/
RUN cp hello-1.0.war /opt/tomcat/webapps/
EXPOSE 8080
CMD /opt/tomcat/bin/catalina.sh run
