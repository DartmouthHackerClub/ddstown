set :application, "ddstown"
set :repository,  "git@github.com:DartmouthHackerClub/ddstown.git"

set :deploy_to, "/home/deploy/ddstown"
set :user, "deploy"
set :use_sudo, false

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "hacktown.cs.dartmouth.edu"                          # Your HTTP server, Apache/etc
role :app, "hacktown.cs.dartmouth.edu"                          # This may be the same as your `Web` server
role :db,  "hacktown.cs.dartmouth.edu", :primary => true # This is where Rails migrations will run

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
