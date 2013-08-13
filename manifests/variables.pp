# Define: bacula::variables
# Parameters:
# arguments
#
define bacula::variables (
    $bacula_password_fd, 
    $bacula_password_sd, 
    $bacula_password_dir,
    $bacula_db_name_dir, 
    $bacula_db_adr_dir, 
    $bacula_db_user_dir, 
    $bacula_db_password_dir) {

    include bacula  
}
