require 'yaml/store'

class Idea
  attr_reader :title, :description, :database

  def initialize(title, description)
    @title = title
    @description = description
  end

  def save
    database.transaction do |db|
      db['ideas'] ||= []
      db['ideas'] << {title: title, description: description}
    end
  end

  def self.database
    @database ||= YAML::Store.new "ideabox"
  end

  def self.all
    raw_ideas.map do |data|
      new(data[:title], data[:description])
    end
  end

  def self.raw_ideas
    database.transaction do |db|
      db['ideas'] || []
    end
  end

  def self.delete(position)
    database.transaction do
      database['ideas'].delete_at(position.to_i)
    end
  end

  def database
    Idea.database
  end
end