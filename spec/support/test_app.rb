# frozen_string_literal: true

require 'sinatra/base'
require 'tilt/erb'
require 'rack'
require 'yaml'

class TestApp < Sinatra::Base
  class TestAppError < StandardError; end
  class TestAppOtherError < StandardError
    def initialize(string1, msg)
      @something = string1
      @message = msg
    end
  end

  set :public_folder, File.join(File.dirname(__FILE__), "../../test_site/html")
  set :static, true
  set :raise_errors, true
  set :show_exceptions, false
end
