desc 'deploy to natalie-lang.org web server'
task :deploy do
  sh 'rsync -avz --exclude=.git ./ deploy@excalibur.71m.us:/var/www/apps/natalie-spec-stats-api/'
  sh 'ssh deploy@natalie-lang.org "cd /var/www/apps/natalie-spec-stats-api/ && bundle install --deployment && touch tmp/restart.txt"'
end

task :cleanup do
  require 'json'
  require 'time'
  path = File.expand_path('./storage/perf_stats.json', __dir__)
  stats = JSON.parse(File.read(path))
  size_before = stats.size
  stats.reject! do |entry|
    entry.dig('stats', 'branch') != 'master' && Time.now - Time.parse(entry['date']) > 7 * 24 * 60 * 60 # 1 week
  end
  raise 'something went wrong' if stats.empty?
  File.write(path, stats.to_json)
  puts "#{size_before - stats.size} removed"
end
