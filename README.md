## Utilisation du module

* Ce module utilise les "hiera", veuillez créer un répertoire "bacula" dans le dossier hieradata.
* Dans ce nouveau répertoire veuillez créer un fichier portant le nom suivant : srv1.dev.yaml
* Ce fichier doit contenir ce qui suit :

```
---
bacula::bacula_client           : 'enable' 
bacula::bacula_server           : 'disabled'
bacula::domaine                 : 'DOMAINE'
bacula::bacula_password_fd      : 'FD_PASSWORD'
bacula::bacula_password_sd      : 'SD_PASSWORD'
bacula::bacula_password_dir     : 'DIR_PASSWORD'
bacula::mysql_new_root_password : 'DB_ROOT_MYSQL'
bacula::bacula_db_name_dir      : 'DB_NAME_MYSQL_DIR'
bacula::bacula_db_user_dir      : 'DB_ACCOUNT_MYSQL_DIR'
bacula::bacula_db_password_dir  : 'DB_PASSWORD_MYSQL_DIR'
```

