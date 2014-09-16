require 'yaml/store'
require_relative 'idea'
require 'pry'

class IdeaStore
  attr_reader :database
  def initialize(filepath)
    @database = YAML::Store.new(filepath)
  end

  def create(data, filedata)
    data["filename"] = filedata[:filename] if filedata
    database.transaction do
      database['ideas'] << data
    end
  end

  # below be class methods

  def self.create(data, filedata)
    data["filename"] = filedata[:filename] if filedata
    database.transaction do
      database['ideas'] << data
    end
  end

  def self.database
    @database ||= YAML::Store.new('db/ideabox')
  end

  def self.delete(position)
    database.transaction do
      database['ideas'].delete_at(position)
    end
  end

  def self.all
    ideas = []
    raw_ideas.each_with_index do |data, i|
      ideas << Idea.new(data.merge("id" => i))
    end
    ideas
  end

  def self.raw_ideas
    database.transaction do |db|
      db['ideas'] || []
    end
  end

  def self.database
    return @database if @database
    @database = YAML::Store.new('db/ideabox')

    @database.transaction do
      @database['ideas'] ||= []
    end
    @database
  end

  def self.find(id)
    raw_idea = find_raw_idea(id)
    Idea.new(raw_idea.merge("id" => id))
  end

  def self.find_raw_idea(id)
    database.transaction do
      database['ideas'].at(id)
    end
  end

  def self.update(id, data, filename=nil)
    data["filename"] = filename
    database.transaction do
      database['ideas'][id] = data
    end
  end
end
