require 'test/unit'
require 'fakeweb'
require File.expand_path('../../test_helper', __FILE__)


class RedmineTocatApiTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    RedmineTocat.settings[:api][:server] = 'http://test.test'
    RedmineTocat.settings[:api][:login] = 'user'
    RedmineTocat.settings[:api][:password] = 'pass'
    @ticket = {"uid" => 1, "ticket_id" => 10000, "budget" => 123}
    @new_ticket = {"uid" => 1, "ticket_id" => 10000, "budget" => 150}
    @project = {"uid" => 1, "project_id" => 14, "budget" => 100.000}
    FakeWeb.register_uri(:get, "http://test.test/project/", :body => "Unauthorized", :status => ["401", "Unauthorized"])
    FakeWeb.register_uri(:get, "http://test.test/ticket/", :body => "Unauthorized", :status => ["401", "Unauthorized"])
    FakeWeb.register_uri(:get, "http://user:pass@test.test/ticket/#{@ticket['ticket_id']}", :body => @ticket.to_json, :status => ["200", "OK"])
    FakeWeb.register_uri(:put, "http://user:pass@test.test/ticket/#{@ticket['ticket_id']}", :body => @new_ticket.to_json, :status => ["200", "OK"], :content_type => "application/json")
    FakeWeb.register_uri(:get, "http://user:pass@test.test/project/#{@project['project_id']}", :body => @project.to_json, :status => ["200", "OK"])

  end

  def test_get_ticket
    assert_equal @ticket["budget"], RedmineTocatApi.get_budget_for_issue(@ticket['ticket_id']), "Problem while getting budget for issue"
  end

  def test_set_ticket
    assert_equal @new_ticket.to_json, RedmineTocatApi.set_budget_for_issue(@ticket['ticket_id'], @new_ticket['budget']), "Problem while setting budget for issue"
  end

  def test_get_project
    assert_equal @project["budget"], RedmineTocatApi.get_budget_for_project(@project['project_id']), "Problem while getting budget for project"
  end

end