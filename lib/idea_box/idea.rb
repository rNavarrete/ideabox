class Idea
  include Comparable
  attr_reader :title, :description, :rank, :id, :filename

  def initialize(attributes={})
    @title       = attributes["title"]
    @description = attributes["description"]
    @filename    = attributes["filename"]
    @rank        = attributes["rank"] || 0
    @id          = attributes["id"]
  end

  def <=>(other)
    rank <=> other.rank
  end

  def to_h
    { "id"          => id,
      "title"       => title,
      "description" => description,
      "rank"        => rank,
      "filename"    => filename
    }
  end

  def like!
    @rank += 1
  end
end
