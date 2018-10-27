#!/usr/bin/env ruby
require 'rest-client'
require 'byebug'
require 'io/console'
require 'yaml'

class PasteBin
  BASE_URL = 'https://pastebin.com/api/api_post.php'.freeze
  DEVKEY = ''.freeze

  def start
    # :TODO handle different privacy levels
    u_key = login_or_read_cached_user_key
    # api_user_key = api_login
    # puts '[pastebin] enter your text'
    # p_text = gets.chomp
    # puts '[pastebin] enter your paste name'
    # p_name = gets.chomp
    # puts '[pastebin] enter your paste format'
    # p_format = gets.chomp
    # puts '[pastebin] enter your paste expire date'
    # ex_date = gets.chomp
    p_text = 'some text'
    p_format = 'ruby'
    p_name = 'first paste'
    ex_date = '10M'
    paste_params = setup_paste_params(p_text, ex_date, p_format, u_key, p_name)
    response = post_request(BASE_URL, paste_params) # max of 150 requests per minute
    if !response.nil? && response.body.include?('https')
      puts "[pastebin] request was successful >>> #{response.body}"
    else
      puts "[pastebin] request was not successful >>> #{response.body}"
    end
  end

  def setup_paste_params(p_text, ex_date, p_format, u_key, p_name)
    request = {}
    request['api_dev_key'] = DEVKEY
    request['api_option'] = 'paste'
    request['api_paste_code'] = p_text
    request['api_paste_private'] = 0
    request['api_paste_name'] = p_name
    request['api_paste_expire_date'] = ex_date
    request['api_paste_format'] = p_format
    request['api_user_key'] = u_key
    request
  end

  def login_or_read_cached_user_key
    if local_api_user_key?
      YAML.load_file('api_user_key.yml')
    else
      base_url = 'https://pastebin.com/api/api_login.php'
      puts '[pastebin] enter your username'
      api_user_name = STDIN.noecho(&:gets).chomp
      puts '[pastebin] enter your password'
      api_user_password = STDIN.noecho(&:gets).chomp
      request_params = setup_login_params(api_user_name, api_user_password)
      response = post_request(base_url, request_params)
      if !response.nil?
        save_api_user_key(response.body)
        return response.body
      else
        # some things went wrong
        puts response.body
      end
    end

    # Creating An 'api_user_key' Using The API Member Login System
    # https://pastebin.com/api/api_login.php
    #  Include all the following POST parameters when you request the url:
    # api_dev_key - this is your API Developer Key, in your case: 8799105de2e42db952cdeb9eab795da8
    # api_user_name - this is the username of the user you want to login.
    # api_user_password - this is the password of the user you want to login.
    # If all 3 values match, a valid user session key will be returned.
    # This key can be used as the api_user_key paramater.

    # Only one key can be active at the same time for the same user.
    # This key does not expire, unless a new one is generated.
    # We recommend creating just one,
    # then caching that key locally as it does not expire.
  end

  def process_json_response(response)
    JSON.parse(response)
  end

  def setup_login_params(user_name, password)
    request = {}
    request['api_user_name'] = user_name
    request['api_user_password'] = password
    request['api_dev_key'] = DEVKEY
    request
  end

  def post_request(url, request_params)
    response = RestClient::Request.execute(method: :post, url: url,
                                          headers: {}, payload: request_params,
                                           timeout: 5)
    response
  end

  def local_api_user_key?
    if File.exist?('api_user_key.yml')
      true
    else
      false
    end
  end

  def save_api_user_key(key)
    file = File.new('api_user_key.yml', 'w')
    file.write(key.to_yaml)
    file.close
  end
end

paste_bin_obj = PasteBin.new
paste_bin_obj.start
