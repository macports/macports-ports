CREATE DATABASE IF NOT EXISTS mythconverg;
GRANT ALL ON mythconverg.* TO mythtv@localhost IDENTIFIED BY "mythtv";
FLUSH PRIVILEGES;
grant all on mythconverg.* to mythtv@"%" identified by "mythtv";
FLUSH PRIVILEGES;
ALTER DATABASE mythconverg DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
FLUSH PRIVILEGES;
