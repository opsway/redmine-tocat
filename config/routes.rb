# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
match '/set_budget' => 'tocat#set_budget', :via => :put
match '/move_issue' => 'tocat#set_order', :via => :put

