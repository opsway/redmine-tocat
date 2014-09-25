module RedmineTocat
  module Hooks
    class ViewsProjectHook < Redmine::Hook::ViewListener
      render_on :view_projects_show_right, :partial => "project/budget"
    end
  end
end