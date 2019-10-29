# Redunda
Status monitoring for SOBotics' bots.

## Installation
Clone the repository first, and change into its directory.

 - **Set up config**  
   Copy `config/config.sample.yml` to `config/config.yml`. Edit the values in the new config file to
   correct values - you'll need an application registered with the SE API via StackApps to get a key,
   client ID, and client secret.
 - **Set database config**  
   Copy `config/database.sample.yml` to `config/database.yml`. Edit the file to add the correct values
   for your environment.
 - **Set secret keys** (prod deployments only)  
   Edit `config/secrets.yml`. Either set a secret directly in the file, or ensure that when you boot
   the server, there's one set in `$ENV["SECRET_KEY_BASE"]`.  
   Edit `config/initializers/devise.rb`. Again, either ensure that `config.secret_key` is set, or that
   you set it from a populated environment variable when the server boots.
 - **Install gems**  
   Run `bundle install`.
 - **Set up the database**  
   Run `rails db:setup RAILS_ENV=production`.
 - **Precompile assets** (prod deployments only)  
   Run `rails assets:precompile RAILS_ENV=production`. You'll also need to ensure you have a public file
   server enabled - either configure Rails to serve your static assets (set 
   `config.public_file_server.enabled = true` in `config/environments/production.rb`), or configure a
   server in front of your application such as Apache or nginx.
 - **Run the server**  
   Run `rails s` with whatever options you choose for your environment.

## License
CC0, or public domain where possible.