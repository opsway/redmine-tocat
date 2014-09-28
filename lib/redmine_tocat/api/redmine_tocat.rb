require 'rest_client'

class RedmineTocatApi


  def self.errors
    @e
  end

  def self.connect
    begin
      project_url = RedmineTocat.settings[:api][:server] + "/project" unless @project_url
      issue_url = RedmineTocat.settings[:api][:server] + "/ticket" unless @issue_url
      login = RedmineTocat.settings[:api][:login] unless @login
      password = RedmineTocat.settings[:api][:password] unless @password
      @project_resource = RestClient::Resource.new(project_url, :user => login, :password => password)
      @issue_resource = RestClient::Resource.new(issue_url, :user => login, :password => password)
      return true
    rescue Exception => @e
      return false
    end
  end

  def self.get_budget_for_project(var)
    begin
      if var.class.name == "Fixnum"
        connect unless @project_resource
        return JSON.parse(@project_resource[var].get)['budget']
      elsif var.class.name == "Project"
        connect unless @project_resource
        return JSON.parse(@project_resource[var.id].get)['budget']
      else
        wrong_argument = true
      end
    rescue Exception => @e

    end
    raise ArgumentError, "Error while getting project budget. Function should use with project object or fixnum, but it get #{var.class.name}", caller if wrong_argument
  end

  def self.get_budget_for_issue(var)
    begin
      if var.class.name == "Fixnum"
        connect unless @issue_resource
        return JSON.parse(@issue_resource[var].get)['budget']
      elsif var.class.name == "Issue"
        connect unless @issue_resource
        return JSON.parse(@issue_resource[var.id].get)['budget']
      else
        wrong_argument = true
      end
    rescue Exception => @e

    end
    raise ArgumentError, "Error while getting project budget. Function should use with project object or fixnum, but it get #{var.class.name}", caller if wrong_argument
  end

  def self.set_budget_for_issue(issue, budget = 0)
    begin
      if issue.class.name == "Fixnum"
        connect unless @issue_resource
        response = JSON.parse(@issue_resource[issue].get)
      elsif issue.class.name == "Issue"
        connect unless @issue_resource
        response = JSON.parse(@issue_resource[issue.id].get)
        issue = issue.id
      else
        wrong_argument = true
      end
    rescue Exception => @e

    end
    raise ArgumentError, "Error while getting project budget. Function should use with project object or fixnum, but it get #{issue.class.name}", caller if wrong_argument
    begin
      json = {
          'uid' => response['uid'],
          'ticket_id' => issue,
          'budget' => budget
      }
      @issue_resource[issue].put json.to_json, :content_type => 'application/json'
    rescue Exception => @e
    end

  end


end