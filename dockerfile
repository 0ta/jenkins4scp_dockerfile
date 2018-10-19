FROM node

FROM jenkins:latest

#node関連設定
USER root
COPY --from=0 /usr/local  /usr/local
RUN npm --version
RUN npm -g config set @sap:registry https://npm.sap.com

#cli install前処理
RUN apt-get update
RUN apt-get install apt-transport-https

#cli install
RUN wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | apt-key add -
RUN echo "deb https://packages.cloudfoundry.org/debian stable main" | tee /etc/apt/sources.list.d/cloudfoundry-cli.list
RUN apt-get update
RUN apt-get install cf-cli

#mtar cf plug-in
RUN mkdir /mtartool
USER jenkins
COPY --chown=jenkins ./cf-cli-mta-plugin.bin /mtartool
RUN cf install-plugin /mtartool/cf-cli-mta-plugin.bin -f

#mtar jarの設定
COPY --chown=jenkins ./mta_archive_builder-1.1.7.jar /mtartool
RUN chmod 700 /mtartool/mta_archive_builder-1.1.7.jar
