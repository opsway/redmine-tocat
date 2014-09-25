require 'test/unit'

class TocatTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get    "projects/1.json",             {}, @matz
      mock.get    "/people/2.xml",             {}, @david
      mock.put    "/people/1.xml",             {}, nil, 204
      mock.delete "/people/1.xml",             {}, nil, 200
      mock.get    "/people/99.xml",            {}, nil, 404
      mock.get    "/people.xml",               {}, "#{@matz}#{@david}"
    end
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  # Fake test
  def test_budget_with_valid_id

  end
end