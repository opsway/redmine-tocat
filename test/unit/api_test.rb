require 'test/unit'
require 'fakeweb'
require File.expand_path('../../test_helper', __FILE__)


class RedmineTocatApiTest < Test::Unit::TestCase

  def setup
    RedmineTocat.settings[:api][:server]   = 'http://test.test'
    RedmineTocat.settings[:api][:login]    = 'user'
    RedmineTocat.settings[:api][:password] = 'pass'
    @ticket_on_server                      = { "uid" => 1, "ticket_id" => 10000, "budget" => 123 }
    @ticket_on_client                      = {"type" => "ticket", "id" => 10000}
    @new_ticket                            = { "uid" => 1, "ticket_id" => 10000, "budget" => 150 }
    @project                               = { "uid" => 1, "project_id" => 14, "budget" => 100.000 }

    FakeWeb.register_uri(:post, "http://user:pass@test.test/getBudget", :body => @ticket_on_server.to_json, :response => ['123',321])
    puts ''
    #FakeWeb.register_uri(:post, "http://user:pass@test.test/getBudget", :body => @ticket.to_json, :parameters => @ticket.to_json, :status => ["200", "OK"], :content_type => "application/json")

  end

  should "get ticket's budget with fixnum passed" do
    assert_equal @ticket_on_server["budget"], RedmineTocatApi.get_budget_for_issue(@ticket_on_server['ticket_id']), "Problem while getting budget for issue"
  end

  should "set ticket budget with fixnum passed" do
    assert_equal true, RedmineTocatApi.set_budget_for_issue(@ticket_on_server['ticket_id'], @new_ticket['budget']), "Problem while setting budget for issue"
  end

  should "get project's budget with fixnum passed" do
    assert_equal @project["budget"], RedmineTocatApi.get_budget_for_project(@project['project_id']), "Problem while getting budget for project"
  end

  should "throw exception when wrong parameter passed" do
    assert_raise ArgumentError do
      RedmineTocatApi.get_budget_for_issue("wrong_parameter")
      RedmineTocatApi.set_budget_for_issue("wrong_parameter")
      RedmineTocatApi.get_budget_for_project("wrong_parameter")
    end
  end

  should "not trow exception when TOCAT service down OR given logicaly wrong argument" do
    assert_nothing_raised Exception do
      RedmineTocatApi.get_budget_for_issue(1)
      RedmineTocatApi.set_budget_for_issue(1)
      RedmineTocatApi.get_budget_for_project(1)
    end
  end

  should "get orders list" do
    #FIXME Пока нет апи тестировать нечего
    assert_equal RedmineTocatApi::ORDERS, RedmineTocatApi.get_orders(1)
  end

  should "move ticket to another order" do
    #FIXME Пока нет апи тестировать нечего
    assert_equal true, RedmineTocatApi.move_issue(1, 1)
  end
end