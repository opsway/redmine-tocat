module RedmineTocat
  module Hooks
    class ViewsProjectHook < Redmine::Hook::ViewListener
      render_on :view_issues_show_details_bottom, :partial => "issue/budget"
      render_on :view_issues_edit_notes_bottom, :partial => "issue/order_select"
    end
  end
end