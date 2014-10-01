require 'rest_client'
require 'base64'

class RedmineTocatApi
  ORDERS = [[1, "Order 1"], [2, "Order 2"], [3, "Order 3"], [4, "Order 4"], [5, "Order 5"]] #FIXME Возвращаем это пока не заработает апи. Потом переписать.


  def self.errors
    @e
  end

  def self.get_budget_for_project(project)
    if project.class.name == "Fixnum"
      request = get(project, "project")
    elsif project.class.name == "Project"
      request = get(project.id, "project")
    else
      raise ArgumentError, "Error while getting project budget. Function should use with project object or fixnum, but it get #{project.class.name}", caller
    end
    JSON.parse(request)['totalBudget'] if request
  end

  def self.get_budget_for_issue(issue)
    if issue.class.name == "Fixnum"
      request = get(issue, "issue")
    elsif issue.class.name == "Issue"
      request = get(issue.id, "issue")
    else
      raise ArgumentError, "Error while getting project budget. Function should use with project object or fixnum, but it get #{issue.class.name}", caller
    end

    JSON.parse(request)['budget'] if request
  end

  def self.set_budget_for_issue(issue, budget = 0)
    if issue.class.name == "Fixnum"
      response = get(issue, "issue")
    elsif issue.class.name == "Issue"
      issue    = issue.id
      response = get(issue, "issue")
    else
      raise ArgumentError, "Error while getting project budget. Function should use with project object or fixnum, but it get #{issue.class.name}", caller
    end
    set(issue, budget, JSON.parse(response)) if response
  end

  def self.get_orders
    orders = []
    JSON.parse(get(1, "orders")).each do |order|
      orders << [order[1]['uid'], order[1]['name']]
    end
    return orders
  end

  def self.get_order(issue)
    if issue.class.name == "Fixnum"
      response = get(issue, "order")
    elsif issue.class.name == "Issue"
      issue    = issue.id
      response = get(issue, "order")
    else
      raise ArgumentError, "Error while getting project budget. Function should use with project object or fixnum, but it get #{issue.class.name}", caller
    end
  end

  def self.move_issue(issue, order)
    set(issue, 1, '', order)
  end

  protected

  def self.get(id, object, project = false)
    url, auth = generate_url(id, 'get')
    begin
      case object
       when 'orders'
          json = {}.to_json
          url, auth = generate_url(id, 'order')
        when 'order'
          url, auth = generate_url(id, 'order')
          if project
            json = {
                'project_id' => id
            }.to_json
          else
            json = {
                'ticket_id' => id
            }.to_json
          end
        when 'issue'
          json = {
              "type" => "ticket",
              'id'   => id
          }.to_json
        when 'project'
          json = {
              "type" => "project",
              'id'   => id
          }.to_json
      end
      RestClient.post(url, json, :accept => :json, :content_type => 'application/json', :authorization => auth ) { |response, request, result, &block|
        case response.code
          when 200
            response
          when 404
            @e = "404, object not found. Looks like TOCAT sever has no record for this object."
            return nil
          else
            response.return!(request, result, &block)
        end
      }
    rescue SocketError => @e
    end
  end

  def self.set(id, budget, issue, order_id = nil)

    begin
      if order_id
        json = {
            'ticket_id' => id,
            'order_uid' => order_id
        }.to_json
        url, auth = generate_url(id, 'set_order')
      else
        json = {
            'type'       => 'ticket',
            'id' => issue['ticket_id'].to_i,
            'budget' => budget
        }.to_json
        url, auth = generate_url(id, 'set')
      end

      RestClient.post(url, json, :content_type => :json, :accept => :json, :authorization => auth) { |response, request, result, &block|
        case response.code
          when 200
            return true
          when 404
            @e = "404, object not found. Looks like TOCAT sever has no record for this object."
            return false
          when 406
            @e = "Server refused to update record."
            return false
        end
      }

    rescue SocketError => @e
    end
  end

  def self.generate_url(id, method)
    login    = RedmineTocat.settings[:api][:login] unless login
    password = RedmineTocat.settings[:api][:password] unless password
    auth     = 'Basic ' + Base64.encode64("#{login}:#{password}").chomp
    #return RedmineTocat.settings[:api][:server] + "/getBudget", auth
     case method
       when 'set_order'
         return RedmineTocat.settings[:api][:server] + "api/rpc/v1/setOrderTicket", auth
       when 'order'
         return RedmineTocat.settings[:api][:server] + "api/rpc/v1/listOrders", auth
       when 'set'
         return RedmineTocat.settings[:api][:server] + "api/rpc/v1/setBudget", auth
       when 'get'
         return RedmineTocat.settings[:api][:server] + "api/rpc/v1/getBudget", auth
     end
  end
end