require_relative 'pingdom_uptime'

start_date = Date.new(2016,12,12)
end_date = Date.new(2016,12,19)
uptime = PingdomUptime.new(
  username: 'my_user_name',
  password: 'my_password',
  api_key: 'my_app_key',
  from: start_date.to_time.to_i,
  to: end_date.to_time.to_i
)
puts 'Getting uptime data'
response = uptime.get
puts JSON.pretty_generate(response)
