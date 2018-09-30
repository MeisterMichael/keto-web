# keto

rake swell_id:install
set config/database.yml
rake db:create
rails active_storage:install
rake db:migrate
