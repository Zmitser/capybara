require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require 'capybara-select2'
require 'selenium-webdriver'
require 'yell'
require 'temp/mail'
require 'base64'
require 'json'
require_relative 'user'


Capybara.default_driver = :selenium
Capybara.app_host = 'https://dev.by'


module MyCapybaraTest
  class DevBy
    include Capybara::DSL
    include Capybara::Node::Actions
    include Capybara::Select2

    def initialize
      @logger = Yell.new STDOUT, :colors => true
      @client = Temp::Mail::Client.new
    end

    def test_google
      users = []
      $i = 0
      $num = Integer(ARGV[0])
      while $i < $num do
        available_domains = @client.available_domains
        user = User.new email_domain: available_domains[0]
        random_username, random_password, email = user.values_at(:username, :password, :email)
        visit('/')
        within(:css, 'div.sign-in') do
          click_link('Регистрация')
        end
        fill_in('user_username', :with => random_username)
        fill_in('user_email', :with => email)
        fill_in('user_password', :with => random_password)
        fill_in('user_password_confirmation', :with => random_password)
        fill_in('user_first_name', :with => 'Gangsta')
        fill_in('user_last_name', :with => 'Nigger')
        fill_in('user_current_position', :with => 'Junior Ruby Developer')
        select2('Avest', from: 'в компании:')
        attach_file('file', '/home/dmitriy/Documents/images.jpg')
        find(:css, '#user_agreement').set(true)
        click_button('Зарегистрироваться')
        response = @client.incoming_emails(email)
        text_message = response[response.size - 1][:mail_text_only]
        page = Nokogiri::HTML.fragment(text_message)
        link = page.at('a')['href']
        visit(link)
        sleep(1)
        user.message = text_message
        users.push user
        $i +=1
      end
      users.each do |user|
        @logger.debug "Username #{user.username} and password #{user.password} and #{user.message}"
      end

    end
  end
end
t = MyCapybaraTest::DevBy.new
t.test_google

