#!/bin/bash

# Use the BACKUP_BASE environment variable, default to "/backups" if not set
backup_base="${BACKUP_BASE:-/backups}"

# Get today's date in YYYYMMDD format
today=$(date +%Y%m%d)

# Create a directory for today's backups
backup_dir="${backup_base}/${today}"
rm -rf "${backup_dir}"
mkdir -p "${backup_dir}"

# Get a list of databases
databases=$(mysql -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | tr -d "| " | grep -v Database)

# Loop through and dump each database
for db in $databases; do
    echo "Dumping database: $db"
    mysqldump -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD --databases $db > "${backup_dir}/${db}.sql"

    # Upload to DigitalOcean Spaces
    aws s3 cp "${backup_dir}/${db}.sql" s3://$AWS_BUCKET/${backup_dir}/${db}.sql --endpoint-url https://$S3_ENDPOINT
done

# Delete local backup files after upload
rm -rf "${backup_dir}"

# Delete backups older than 60 days from DigitalOcean Spaces
older_than=$(date --date="60 days ago" +%Y%m%d)
aws s3 rm s3://$AWS_BUCKET/$backup_base --recursive --endpoint-url https://$S3_ENDPOINT --exclude "*" --include "${older_than}/*"
