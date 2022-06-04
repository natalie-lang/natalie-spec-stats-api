require 'bundler/setup'
require 'json'
require 'time'
require 'sinatra'

STATS_PATH = File.expand_path('./storage/stats.json', __dir__)
SELF_HOSTED_STATS_PATH = File.expand_path('./storage/self_hosted_stats.json', __dir__)
CURRENT_STATS_PATH = File.expand_path('./storage/current.json', __dir__)
SECRET = ENV['SECRET'].freeze

get '/' do
  redirect 'https://natalie-lang.org'
end

get '/stats' do
  "POST stats to this endpoint with params 'secret' and 'stats' (JSON)"
end

post '/stats' do
  if params[:secret].to_s != SECRET
    halt 401, 'must pass "secret" param with correct secret'
  end
  unless params[:stats]
    halt 400, 'must pass "stats" param with json string'
  end
  stats = JSON.parse(File.read(STATS_PATH)) rescue []

  new_stats = JSON.parse(params[:stats])
  current_time = Time.now.utc.strftime('%Y-%m-%dT%I:%M:%SZ')

  details = new_stats.delete("Details")
  File.write(CURRENT_STATS_PATH, { date: current_time, stats: details }.to_json)

  stats.unshift(date: current_time, stats: new_stats)
  File.write(STATS_PATH, stats.to_json)

  status 201
  'ok'
end

post '/self_hosted_stats' do
  if params[:secret].to_s != SECRET
    halt 401, 'must pass "secret" param with correct secret'
  end
  unless params[:stats]
    halt 400, 'must pass "stats" param with json string'
  end
  stats = JSON.parse(File.read(SELF_HOSTED_STATS_PATH)) rescue []

  new_stats = JSON.parse(params[:stats])
  current_time = Time.now.utc.strftime('%Y-%m-%dT%I:%M:%SZ')
  stats.unshift(date: current_time, stats: new_stats)
  File.write(SELF_HOSTED_STATS_PATH, stats.to_json)

  status 201
  'ok'
end
