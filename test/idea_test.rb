require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'
require_relative '../lib/idea_box/idea'

describe Idea do
  def title()       'some title'       end
  def description() 'some description' end
  def rank()        10                 end
  def id()          12                 end
  def filename()    'some/filename'    end

  def idea
    @idea ||= Idea.new('title'       => title,
                       'description' => description,
                       'rank'        => rank,
                       'id'          => id,
                       'filename'    => filename)
  end

  it 'has a title, description, rank, id, and filename' do
    assert_equal idea.title       , title
    assert_equal idea.description , description
    assert_equal idea.rank        , rank
    assert_equal idea.id          , id
    assert_equal idea.filename    , filename
  end

  it 'defaults its rank to 0 if one is not provided' do
    assert_equal 0, Idea.new.rank
  end

  it 'determines its comparability by its rank -- higher is better' do
    assert Idea.new('rank' => 1) < Idea.new('rank' => 2)
    assert Idea.new('rank' => 2) > Idea.new('rank' => 1)
    assert Idea.new('rank' => 1) == Idea.new('rank' => 1)
  end

  it 'renders its attributes when we call to_h' do
    assert_equal idea.to_h, {
      "id"          => id,
      "title"       => title,
      "description" => description,
      "rank"        => rank,
      "filename"    => filename,
    }
  end

  it 'increments its rank when it gets liked' do
    idea = Idea.new('rank' => 5)
    assert_equal 5, idea.rank
    idea.like!
    assert_equal 6, idea.rank
  end
end
