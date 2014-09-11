require_relative 'test_helper'

require 'sinatra/assetpack'
require 'rack/test'
require_relative '../lib/app'

describe 'my app' do
  include Rack::Test::Methods

  def app
    IdeaBoxApp.new
  end


  describe 'homepage' do
    it 'can search my ideas'
    it 'can display existing ideas'

    describe 'adding an idea' do
      it 'gives me a form to add a new idea' do
        last_response = get '/'
        assert last_response.ok?
        doc  = Nokogiri::HTML(last_response.body)
        form = doc.at_css('form[action="/"]')
        assert form.at_css('textarea[name="idea[description]"]')
        assert form.at_css('input[name="idea[title]"]')
      end

      def idea_store
        IdeaStore
      end

      it 'can add ideas without images' do
        initial_count = idea_store.all.count
        post '/', {
          idea: {
            description: 'some description',
            title:       'some title',
          }
        }
        assert_equal 302, last_response.status
        assert_equal initial_count+1, idea_store.all.count
        idea = idea_store.all.last
        assert_equal 'some description', idea.description
        assert_equal 'some title',       idea.title
      end
    end
  end
end
