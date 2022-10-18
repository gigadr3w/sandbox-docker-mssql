DECLARE @DBCount INT

SELECT @DBCount = COUNT([name]) FROM sys.databases WHERE [name] = 'MyLovelyAW'

IF @DBCount = 0
BEGIN
    CREATE DATABASE MyLovelyAdventureWorks

    RESTORE DATABASE MyLovelyAdventureWorks FROM DISK = '/srv/db-init/MyLovelyAdventureWorks.bak'
    WITH MOVE 'MyLovelyAdventureWorks' TO '/srv/db-data/MyLovelyAdventureWorks.mdf', 
    MOVE 'MyLovelyAdventureWorks_log' TO '/srv/db-data/MyLovelyAdventureWorks_log.ldf',
    REPLACE
END

