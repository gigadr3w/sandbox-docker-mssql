Sandbox-docker-mssql 
====================

This is a simple tutorial to how make a Microsoft SQL Server Express Docker container sandbox with data persistency, starting from an existing database backup.
It's my opinion that docker can be usefull in the development or staging environment as well as in production.
The major advantage is that you will not have service dependencies in your phisycal machine but a dedicated, more ligh-weight virtual environmnent that you can switch off and on as your need.  

## Requirements

Obviously you need: 

* [Docker](https://www.docker.com/) - to build your docker image.
* [Docker compose](https://docs.docker.com/compose/) - to set up your [volume](https://docs.docker.com/storage/volumes/) for your data persistency.

    avviare la shell da cartella.

1- Buildare il container (-t [nome_immagine], nel nostro caso *nw4-db*) eseguendo nella *medesima cartella del Dockerfile*

```shell
sudo docker build -t nw4-db .
```

2 - una volta compilata l'immagine eseguiamo il container (-p [porta_locale:porta_container(sempre 1433)] per esporre la porta, -d silent mode)

```shell
sudo docker run -p "1433:1433" --name nw4-db-instance -d nw4-db
```

3 - Attendiamo almeno > 30 sec (è stato impostato uno sleep perchè il restore partisse DOPO che il servizio MSSQL viene avviato) per connettersi al container (a livello server, come fosse una ssh su un server remoto, per intenderci)

```shell
sudo docker exec -it nw4-db-instance /bin/bash
```

4 - una volta dentro, eseguiamo il *sqlcmd* (supponiamo di voler entrare nel master)

```shell
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $SA_PASSWORD -d master
```

NB - ogni comando dovrà essere seguito dalla direttiva "GO" per procedere all'esecuzione (F5)

ES. 

```SQL
SELECT @@VERSION;
GO
```

per *TERMINARE* l'esecuzione del container

```shell
sudo docker stop nw4-db-instance
```

# NB - ogni volta che si aggiorna il .bak ripartire dal punto 1