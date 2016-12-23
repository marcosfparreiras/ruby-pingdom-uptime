require 'httparty'
require 'json'

class PingdomUptime
  def initialize(options)
    @auth = {
      username: options[:username],
      password: options[:password]
    }
    @headers = { 'app-key' => options[:api_key] }
    @base_url = 'https://api.pingdom.com/api/2.0/'
    @from = options[:from]
    @to = options[:to]
  end

  def get
    all_checks = checks.each do |check|
      check_uptime =  uptime(check['id'])
      check.merge!('uptime' => check_uptime)
    end
    all_checks
  end

  private

  def uptime(check_id)
    response = request('summary.average/' + check_id.to_s, uptime_query)
    status = JSON.parse(response.body)['summary']['status']
    status['totalup'].to_f / status.values.inject(:+)
  end

  def checks
    response = request('checks')
    JSON.parse(response.body)['checks']
  end

  def uptime_query
    {
      from: @from,
      to: @to,
      includeuptime: true
    }
  end

  def request(endpoint, query = {})
    response = HTTParty.get(
      @base_url + endpoint,
      :query => query,
      :headers => @headers,
      :basic_auth => @auth
    )
  end
end
