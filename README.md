# keto

rake swell_id:install
set config/database.yml
rake db:create
rails active_storage:install
rake db:migrate

rake pulitzer:install
rake scuttlebutt:install
rake bazaar:install
rake bunyan:install
rake edison:install
rake socratic:install
rake db:migrate
