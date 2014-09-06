require './idea'

class IdeaBoxApp < Sinatra::Base

  configure :development do
    register Sinatra::Reloader
  end


  get '/' do
    erb :index
  end

  not_found do
    erb :error
  end

  post '/' do
    idea = Idea.new(params["idea_title"], params["idea_description"])
    idea.save
    "Creating an idea!"
  end

end