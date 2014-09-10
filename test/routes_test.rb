require 'sinatra/assetpack'
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'
require 'rack/test'

require_relative '../lib/app'

describe idea_box do
  include Rack::Test::Methods

  def app
    IdeaBoxApp.new
  end

  it "tells you how great today is going to be" do
    get '/'
    assert_equal 200, last_response.status
    assert last_response.ok?
  end
end