docker exec -i mysql mysql -uroot -pErryial123 -e "CREATE database fivem;"
docker exec -i mysql mysql -uroot -pErryial123 fivem < ./database_init.sql
docker exec -i mysql mysql -uroot -pErryial123 -e "CREATE USER 'user'@'*' IDENTIFIED BY 'Erryial123';"
docker exec -i mysql mysql -uroot -pErryial123 -e "GRANT ALL PRIVILEGES ON fivem.* TO 'user'@'*';"
docker exec -i mysql mysql -uroot -pErryial123 -e "FLUSH PRIVILEGES;"
