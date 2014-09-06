require './idea'

class IdeaBoxApp < Sinatra::Base

  set :method_override, true

  configure :development do
    register Sinatra::Reloader
  end


  get '/' do
    erb :index, locals: {ideas: Idea.all}
  end

  not_found do
    erb :error
  end

  post '/' do
    idea = Idea.new(params["idea_title"], params["idea_description"])
    idea.save
    redirect '/'
  end

  delete '/:id' do |id|
    Idea.delete(id)
    redirect '/'
  end

end