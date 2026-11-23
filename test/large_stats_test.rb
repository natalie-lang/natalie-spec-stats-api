ENV['RACK_ENV'] = 'test'
ENV['SECRET'] = 'test-secret'

require 'test/unit'
require 'rack/test'
require_relative '../app'

class LargeStatsTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_large_url_encoded_report_reaches_authentication
    header 'Host', 'localhost'
    post '/stats', secret: 'incorrect', stats: 'x' * (6 * 1024 * 1024)

    assert_equal 401, last_response.status
    assert_match(/secret/, last_response.body)
  end
end
