FROM ubuntu
RUN apt update && apt install -y \
    default-jdk \
    maven \
    git
RUN groupadd tomcat
RUN useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
WORKDIR /tmp
RUN curl -O https://dlcdn.apache.org/apache-tomcat-9.0.55.tar.gz
RUN mkdir /opt/tomcat
RUN tar xzvf apache-tomcat-9.0.55.tar.gz -C /opt/tomcat --strip-components=1
WORKDIR /opt/tomcat/
RUN chgrp -R tomcat /opt/tomcat
RUN chmod -R g+r conf
RUN chmod g+x conf
RUN chown -R tomcat webapps/ work/ temp/ logs/
RUN systemctl start tomcat
EXPOSE 8080
WORKDIR /home/boxfuse/
RUN git clone  https://github.com/boxfuse/boxfuse-sample-java-war-hello.git
WORKDIR boxfuse-sample-java-war-hello/
RUN mvn package
WORKDIR target/
RUN cp hello-1.0.war /opt/tomcat/webapps/
CMD ["catalina.sh" "run"]
