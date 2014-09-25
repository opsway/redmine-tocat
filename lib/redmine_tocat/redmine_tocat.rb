
Rails.configuration.to_prepare do
  #all internal files MUST be described here

  #classes

  #patches

  #hooks
  require 'redmine_tocat/hooks/view_project_hook'
  require 'redmine_tocat/hooks/view_issue_hook'
end

module RedmineTocat

  def self.settings() Setting[:plugin_redmine_tocat].blank? ? {} : Setting[:plugin_redmine_tocat]  end

end