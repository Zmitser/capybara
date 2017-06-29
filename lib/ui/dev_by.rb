require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require 'capybara-select2'
require 'selenium-webdriver'
require 'yell'
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
    end

    def test_google
      users = []
      $i = 0
      $num = Integer(ARGV[0])
      while $i < $num do
        visit('/')
        within(:css, 'div.sign-in') do
          click_link('Регистрация')
        end
        random_string = (('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a).sample(8).join
        random_password = (('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a).sample(8).join
        fill_in('user_username', :with => random_string)
        fill_in('user_email', :with => "#{random_string}@tut.by")
        fill_in('user_password', :with => random_password)
        fill_in('user_password_confirmation', :with => random_password)
        fill_in('user_first_name', :with => 'Zmitser')
        fill_in('user_last_name', :with => 'Lisitsin')
        fill_in('user_current_position', :with => 'Junior Ruby Developer')
        select2('Avest', from: 'в компании:')
        attach_file('file', '/home/dmitriy/Documents/images.jpg')
        find(:css, '#user_agreement').set(true)
        click_button('Зарегистрироваться')
        user = User.new username: random_string,
                        password: random_password
        users.push user
        $i +=1
      end

      users.each do |user|
        @logger.debug "Username #{user.username} and password #{user.password}"
      end

    end
  end
end
t = MyCapybaraTest::DevBy.new
t.test_google

