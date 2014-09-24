
Rails.configuration.to_prepare do
  #all internal files MUST be described here

  #classes

  #patches

  #hooks
end

module RedmineTocat

  def self.settings() Setting[:plugin_redmine_tocat].blank? ? {} : Setting[:plugin_redmine_tocat]  end

end