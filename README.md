Sandbox-docker-mssql 
====================

This is a simple tutorial on how to make a Microsoft SQL Server Express Docker container sandbox with data persistency, starting from an existing database backup.
It's in my opinion that docker can be usefull in the development or staging environment as well as in production.
The major advantage is that you will not have service dependencies in your phisycal machine but a dedicated, more ligh-weight virtual environmnent that you can switch off and on as your needs.  

## Requirements

* [Docker](https://www.docker.com/) - to build your docker image.
* [Docker compose](https://docs.docker.com/compose/) - to set up your [volume](https://docs.docker.com/storage/volumes/) for your data persistency, and exec the container easily (ok, it's not a requirement but it's very usefull)

## How To

1. Backup the database you want to "dockerize" (in my case an _MyLovelyAdventureWorks_ DB). 
Open your MSSQL console and type

```SQL
BACKUP DATABASE MyLovelyAdventureWorks TO DISK = 'MyLovelyAdventureWorks.bak';
```

move the backup file within ```/init``` folder. Notice, I've used a single database for my mssql docker instance, but it's obvious that you can restore more then one. 

It's pretty sure you'll have to change the restore location of your db-files, as the container filesystem won't match with yours. If you don't know the database file names (data && log), you can retrieve them from your backup file, typing in the same mssql console

```SQL
RESTORE FILELISTONLY FROM DISK = 'MyLovelyAdventureWorks.bak';
```

![Logic names](/imgs/logical_names.png)

2. Change ```/init/setup.sql``` file.

    ##### NOTICE - Actually there is a bug (?) with the MSSQL2019 image on Docker > 2.2.0.5, it can't restore db files within a volume folder mounted from the host

    We need to make a workaround, I've tried many ways but only this works

    As the ```/srv/db-data/``` has been configured as the default MSSQL file folder thanks to the Dockerfile, within **/init/setup.sql** at first we create the database with the same name of the database that will be restored and then, we restore the same database replacing files.

```SQL
    CREATE DATABASE MyLovelyAdventureWorks

    RESTORE DATABASE MyLovelyAdventureWorks FROM DISK = '/srv/db-init/MyLovelyAdventureWorks.bak'
    WITH MOVE 'MyLovelyAdventureWorks' TO '/srv/db-data/MyLovelyAdventureWorks.mdf', 
    MOVE 'MyLovelyAdventureWorks_log' TO '/srv/db-data/MyLovelyAdventureWorks_log.ldf',
    REPLACE
```

3. Now build the container. I use a WSL with which I handle my virtual environments but you can use Powershell instead. Open the shell, navigate to the current Dockerfile folder and then type

```shell
    docker build -t [name-of-your-image] .
```

##### NOTICE -t parameter is used to give a name to the docker image. It is usefull to run the container instance, and it must have the same name of the image required into docker-compose.yml. In my case it will be:

```shell
    docker build -t aw-db .
```

as my docker-compose.yml is: 

```yml
services:
  aw-db:
    container_name: "aw-db-instance" 
    image: aw-db
    ports:
      - "1433:1433"
    volumes:
      - ./db-data:/srv/db-data
```

4. If nothing goes wrong, now you can start your container instance, typing in the same folder

```shell
docker-compose up 
```

You have to wait 15 seconds (if you need to encrease the delay you can do it modifying ```/init/setup.sh```), to make sure that mssql instantiate all system databases

5. Then you can access to your container console typing 

```shell
exec -it aw-db-instance /bin/bash
```

6. And access to sql console *sqlcmd* 

```shell
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $SA_PASSWORD -d MyLovelyAdventureWorks
```

7. Make a query statement for select all tables name
 

```SQL
SELECT name FROM sys.tables;
GO
```