module RedmineTocat
  module Hooks
    class ViewsProjectHook < Redmine::Hook::ViewListener
      render_on :view_issues_show_details_bottom, :partial => "issue/budget"
    end
  end
end