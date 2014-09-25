Redmine::Plugin.register :redmine_tocat do
  name 'Redmine Tocat plugin'
  author 'Aleksander Gornov'
  description 'This is a Redmine client for TOCAT service'
  version '0.0.1'
  url 'https://github.com/opsway/tocat'
  author_url 'http://opsway.com/'


  requires_redmine :version_or_higher => '2.0.3'


  settings :default => {
  }, :partial => 'settings/settings'

end
 require 'redmine_tocat/redmine_tocat'