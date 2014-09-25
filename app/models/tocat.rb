class Tocat < ActiveResource::Base
  self.site = RedmineTocat.settings[:api][:server]
  self.user = RedmineTocat.settings[:api][:login]
  self.password = RedmineTocat.settings[:api][:password]
  self.collection_name = 'project'

  def self.errors
    @errors
  end

  def self.project_budget(project)
    set_settings if self.site.nil? or self.user.nil? or self.password.nil?
    raise ArgumentError unless project.class.name == "Project" or project.class.name == "Fixnum"
    begin
      if project.class.name == "Project"
        Tocat.find(project.id).budget.to_f
      elsif project.class.name == "Fixnum"
        Tocat.find(project).budget.to_f
      end
    rescue Exception => @errors
      nil
    end
  end

  def self.issue_budget(issue)
    set_settings if self.site.nil? or self.user.nil? or self.password.nil?
    raise ArgumentError unless issue.class.name == "Issue" or issue.class.name == "Fixnum"
    if issue.class.name == "Issue"
      project = issue.project
    elsif issue.class.name == "Fixnum"
      project = Issue.find(issue)
    else
      return nil
    end
    #TODO добавить геттер бюджета для задачи
    #
    # begin
    #   Tocat.find()
    # rescue Exception => @errors
    #   nil
    # end
  end

  protected

  def self.set_settings
    self.site = RedmineTocat.settings[:api][:server]
    self.user = RedmineTocat.settings[:api][:login]
    self.password = RedmineTocat.settings[:api][:password]
    self.collection_name = 'project'
  end

end