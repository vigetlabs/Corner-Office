~* CornerOffice *~


Install
=======

`bundle`

`cp config/database.yml.example config/database.yml`

edit config/database.yml with your local settings

bundle exec rake db:create db:migrate db:seed
