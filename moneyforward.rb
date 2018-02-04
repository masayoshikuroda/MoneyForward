require 'selenium-webdriver'
require 'net/http'
require 'uri'
require 'date'

class MoneyForward
  BASE_URL = 'https://moneyforward.com'

  def initialize
    pwd = Dir.pwd
    prefs = {
      prompt_for_download: false,
      default_directory: pwd
    }
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_preference(:download, prefs)
    @driver = Selenium::WebDriver.for :chrome, options: options
    @driver.manage.timeouts.implicit_wait = 10
  end

  def login(user, pass)
    @driver.navigate.to BASE_URL + '/users/sign_in'
    form = @driver.find_element(:id, 'new_sign_in_session_service')
    form.find_element(:id, 'sign_in_session_service_email').send_keys(user)
    form.find_element(:id, 'sign_in_session_service_password').send_keys(pass)
    form.find_element(:id, 'login-btn-sumit').click
  end

  def logout
    @driver.find_element(:xpath, '//a[@data-method="delete"]').click
  end

  def download_csv(year, month)
      url=BASE_URL + sprintf('/cf/csv?year=%04d&month=%02d', year, month)
      @driver.navigate.to url
      p '=== Download ' + year.to_s + '/' + month.to_s + '==='
  end
end
