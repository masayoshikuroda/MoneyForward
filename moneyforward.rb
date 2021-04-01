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
      default_directory: pwd,
      directory_upgrade: true
    }
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_preference(:download, prefs)
    @driver = Selenium::WebDriver.for :chrome, options: options
    @driver.manage.timeouts.implicit_wait = 10
  end

  def login(user, pass)
    @driver.navigate.to 'https://id.moneyforward.com/sign_in/email'
    form = @driver.find_element(:xpath, "//form[@action='/sign_in/email']")
    form.find_element(:name, 'mfid_user[email]').send_keys(user)
    form.find_element(:xpath, "//input[@type='submit']").click
    
    form = @driver.find_element(:xpath, "//form[@action='/sign_in']")
    form.find_element(:name, 'mfid_user[password]').send_keys(pass)
    form.find_element(:xpath, "//input[@type='submit']").click

    @driver.navigate.to BASE_URL + '/sign_in'
    form = @driver.find_element(:xpath, "//form[@method='post']")
    form.find_element(:xpath, "//input[@type='submit']").click
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
