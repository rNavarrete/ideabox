require_relative './idea_box'
require 'sinatra/assetpack'
require 'pry'


class IdeaBoxApp < Sinatra::Base
  register Sinatra::AssetPack

  set :method_override, true
  set :root, 'lib/app/'


  configure :development do
    register Sinatra::Reloader
  end

  get '/stylesheets/:name.css' do
    content_type 'text/css', :charset => 'utf-8'
    sass(:"stylesheets/#{params[:name]}", Compass.sass_engine_options )
  end

  assets do
    serve '/js', from: 'js'
    serve '/bower_components', from: 'bower_components'

    js :modernizr, [
      '/bower_components/modernizr/modernizr.js',
    ]

    js :libs, [
      '/bower_components/jquery/dist/jquery.js',
      '/bower_components/foundation/js/foundation.js',
      '/bower_components/sidr/jquery.sidr.min.js',
      '/bower_components/tubular/tubular.js',
      '/bower_components/mosaiqy/mosaiqy-1.0.2.min.js'
    ]

    js :application, [
      '/js/app.js'
    ]

    js_compression :jsmin
  end

  get '/' do
    erb :index, locals: {ideas: IdeaStore.all.sort, idea: Idea.new(params)}
  end

  not_found do
    erb :error
  end

  get '/search' do
    query   = params["query"].split(" ")
    results = []
    IdeaStore.all.select do |idea|
      query.each do |search_word|
        if idea.description.downcase =~ /#{search_word}/ || idea.title.downcase =~ /#{search_word}/
          results << idea
        end
      end
    end
    erb :search_results, locals: {results: results}
  end

  post '/' do
    IdeaStore.create(params[:idea], params['myfile'])
    File.open('lib/app/public/images/' + params['myfile'][:filename], "w") do |f|
      f.write(params['myfile'][:tempfile].read)
    end
    redirect '/'
  end

  delete '/:id' do |id|
    IdeaStore.delete(id.to_i)
    redirect '/#sidr'
  end

  get '/:id/edit' do |id|
    idea = IdeaStore.find(id.to_i)
    erb :edit, locals: {idea: idea}
  end

  put '/:id' do |id|
    IdeaStore.update(id.to_i, params['idea'], params['myfile'])
    redirect '/'
  end


  post '/:id/like' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.like!
    IdeaStore.update(id.to_i, idea.to_h)
    redirect '/'
  end
end