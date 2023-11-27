# mysql-backup

Backup mysql database daily

```
docker run -d \
    -e MYSQL_HOST=your_mysql_host \
    -e MYSQL_USER=your_mysql_user \
    -e MYSQL_PASSWORD=your_mysql_password \
    -e AWS_ACCESS_KEY_ID=your_access_key \
    -e AWS_SECRET_ACCESS_KEY=your_secret_key \
    -e AWS_DEFAULT_REGION=your_region \
    -e AWS_BUCKET=your_bucket_name \
    -e S3_ENDPOINT=your_spaces_endpoint \
    -e BACKUP_BASE=/path/to/your/backup/dir \
    my-mysql-backup
```