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
    JSON.parse(request)['budget'] if request
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

  def self.get_orders(issue)
    ORDERS #FIXME Возвращаем это пока не заработает апи. Потом переписать.
  end

  def self.move_issue(issue, order)
    #FIXME переносим тикет в другой ордер. Пока нет апи - возврашаем 1
    true
  end

  protected

  def self.get(id, object)
    url, auth = generate_url(id, object)
    begin
      if object == 'project'
        RestClient.get(url, { :accept => :json, :authorization => auth }) { |response, request, result, &block|
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
      elsif object == 'issue'
        RestClient.get(url, { :accept => :json, :authorization => auth }) { |response, request, result, &block|
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
      end
    rescue SocketError => @e
    end
  end

  def self.set(id, budget, issue)
    url, auth = generate_url(id, 'issue')
    begin
      json = {
          'uid'       => issue['uid'].to_i,
          'ticket_id' => issue['ticket_id'].to_i,
          'budget' => budget
      }.to_json

      RestClient.put(url, json, :content_type => :json, :accept => :json, :authorization => auth) { |response, request, result, &block|
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

  def self.generate_url(id, object)
    login    = RedmineTocat.settings[:api][:login] unless login
    password = RedmineTocat.settings[:api][:password] unless password
    auth     = 'Basic ' + Base64.encode64("#{login}:#{password}").chomp
    case object
      when 'project'
        return RedmineTocat.settings[:api][:server] + "/project/#{id}", auth
      when 'issue'
        return RedmineTocat.settings[:api][:server] + "/ticket/#{id}", auth
    end
  end
end