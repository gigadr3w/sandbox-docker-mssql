# Arbitrary waiting time to ensure that the SQL istance is running:
sleep 15s

# Execute the sql script
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $SA_PASSWORD -d master -i setup.sql