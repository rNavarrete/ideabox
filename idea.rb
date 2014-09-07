require_relative 'idea_store'

class Idea
  attr_reader :title, :description, :database

  def initialize(attributes={})
    @title = attributes["title"]
    @description = attributes["description"]
    @rank = attributes['rank']
  end


  def save
    IdeaStore.create(to_h)
  end

  def to_h
    {
      "title" => title,
      "description" => description,
      "rank" => rank
    }
  end
end