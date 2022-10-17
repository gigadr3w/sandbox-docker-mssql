FROM mcr.microsoft.com/mssql/server:2019-CU15-ubuntu-20.04

# License 
ENV ACCEPT_EULA=Y
# admin password
ENV SA_PASSWORD=!Ath0$_2023

#change user to create folders
USER root

#set ENV variables 
ARG APP_DIR=/srv/db-init
ARG DB_DIR=/srv/db-data

RUN mkdir -p $APP_DIR
RUN mkdir -p $DB_DIR
WORKDIR $APP_DIR
COPY ./init/ ./

#change folders permissions, becouse the container will run without root privileges
RUN chmod +x $APP_DIR/entrypoint.sh
RUN chmod +x $APP_DIR/setup.sh

CMD ["/bin/bash", "entrypoint.sh"]