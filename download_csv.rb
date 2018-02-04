require 'optparse'
require './moneyforward.rb'

params = ARGV.getopts("", 'user:', 'pass:', 'begin-year:', 'begin-month:', 'months:') 
user = params['user']
pass =  params['pass']
date = Date.new(params['begin-year'].to_i, params['begin-month'].to_i, 1)
months = params['months'].to_i

mf = MoneyForward.new
mf.login(user, pass)
(1..months).each do |m|
  year = date.year
  month = date.month
  mf.download_csv(year, month)
  date = date >> 1
end
mf.logout
