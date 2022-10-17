# 1. Execute SQL Server
# 2. Execute the script file that restore the database
# 3. Start the container for a inteterminate time
/opt/mssql/bin/sqlservr & ./setup.sh & sleep infinity & wait