/*
NOTICE

It's pretty sure you will change the restore location of your db-files as the container filesystem won't match with yours.
if you don't know the database file names (data && log), you can retrieve them from your backup file, typing in a mssql console
 
RESTORE FILELISTONLY FROM DISK = 'MyLovelyAdventureWorks.bak';
*/

DECLARE @DBCount INT

SELECT @DBCount = COUNT([name]) FROM sys.databases WHERE [name] = 'MyLovelyAW'

IF @DBCount = 0
BEGIN
    RESTORE DATABASE [NW4-global] FROM DISK = '/srv/db-init/Nw4-Global-Andrea.bak'
    WITH MOVE 'MyLovelyAdventureWorks' TO '/srv/db-data/MyLovelyAdventureWorks.mdf', MOVE 'MyLovelyAdventureWorks_log' TO '/srv/db-data/MyLovelyAdventureWorks_log.ldf'
    
    /*
    ONLY FOR DEMO PURPOSE
    If you want, you may add more SQL instructions.
    */
    CREATE TABLE SandboxTable (Id INT IDENTITY(1,1) PRIMARY KEY, FakeColumn1 VARCHAR(100), FakeColumn2 VARCHAR(100))
    INSERT INTO SandboxTable (FakeColumn1, FakeColumn2) VALUES ('Lorem', 'Ipsum')
END

