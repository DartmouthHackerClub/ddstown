set :application, "ddstown"
set :repository,  "git@github.com:DartmouthHackerClub/ddstown.git"

set :deploy_to, "/var/www/dds.1337.cx"
set :user, "deploy"
set :use_sudo, false

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "dds.1337.cx"                          # Your HTTP server, Apache/etc
role :app, "dds.1337.cx"                          # This may be the same as your `Web` server
role :db,  "dds.1337.cx", :primary => true # This is where Rails migrations will run

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :db do
  desc <<-DESC
      [internal] Updates the symlink for database.yml file to the just deployed release.
  DESC
  task :symlink, :except => { :no_release => true } do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

  after "deploy:finalize_update", "db:symlink"
end
