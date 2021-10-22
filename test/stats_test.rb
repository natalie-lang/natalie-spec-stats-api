ENV['APP_ENV'] = 'test'

require './app'
require 'test/unit'
require 'rack/test'

class StatsTest < Test::Unit::TestCase
  include Rack::Test::Methods
  SECRET = File.read('secret.txt').strip.freeze
  STATS_PATH = File.expand_path('../public/stats.json', __dir__)
  CURRENT_STATS_PATH = File.expand_path('../public/current.json', __dir__)

  def app
    Sinatra::Application
  end

  def setup
    File.unlink(STATS_PATH) if File.exist?(STATS_PATH)
    File.unlink(CURRENT_STATS_PATH) if File.exist?(CURRENT_STATS_PATH)
  end

  def test_fail_without_secret
    post '/stats'
    assert last_response.unauthorized?
    assert_equal 'must pass "secret" param with correct secret', last_response.body
  end

  def test_fail_without_stats_passed
    post '/stats', secret: SECRET
    assert last_response.bad_request?
    assert_equal 'must pass "stats" param with json string', last_response.body
  end

  def test_upload_stats
    stats_example = {
      'Successful Examples' => 317,
      'Failed Examples' => 216,
      'Errored Examples' => 128,
      'Compile Errors' => 4,
      'Crashes' => 3,
      'Timeouts' => 1,
      'Details' => {
        'core' => {
          'array' => {
            'reject_spec' => {
              'compiled' => true,
              'timeouted' => false,
              'crashed' => false,
              'success' => 17,
              'failures' => 0,
              'errors' => 0,
              'error_messages' => []
            }
          }
        }
      }
    }

    post '/stats', secret: SECRET, stats: stats_example.to_json
    assert last_response.created?
    assert_equal 'ok', last_response.body

    saved_stats = JSON.parse(File.read(STATS_PATH))
    assert_equal 1, saved_stats.size
    assert_equal Date.today, Date.parse(saved_stats.first['date'])
    assert_equal stats_example.reject { |k, _| k == 'Details' }, saved_stats.first['stats']

    current_stats = JSON.parse(File.read(CURRENT_STATS_PATH))
    assert_equal Date.today, Date.parse(current_stats['date'])
    assert_equal stats_example["Details"], current_stats['stats']
  end

  def test_upload_multiple_stats
    stats_example = {
      'Successful Examples' => 317,
      'Failed Examples' => 216,
      'Errored Examples' => 128,
      'Compile Errors' => 4,
      'Crashes' => 3,
      'Timeouts' => 1,
      'Details' => {}
    }

    post '/stats', secret: SECRET, stats: stats_example.to_json
    assert last_response.created?

    saved_stats = JSON.parse(File.read(STATS_PATH))
    assert_equal 1, saved_stats.size

    stats_example["Successful Examples"] = 1
    post '/stats', secret: SECRET, stats: stats_example.to_json
    saved_stats = JSON.parse(File.read(STATS_PATH))

    assert_equal 2, saved_stats.size
    assert_equal 1, saved_stats.first['stats']['Successful Examples']
  end
end
