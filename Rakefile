desc 'deploy to natalie-lang.org web server'
task 'deploy' do
  sh 'rsync -avz --exclude=.git ./ deploy@excalibur.71m.us:/var/www/apps/natalie-spec-stats-api/'
  sh 'ssh deploy@natalie-lang.org "cd /var/www/apps/natalie-spec-stats-api/ && bundle install --deployment && touch tmp/restart.txt"'
end
