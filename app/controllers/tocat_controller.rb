class TocatController < ApplicationController
  unloadable


  def set_budget
    ticket = params[:ticket_id].to_i
    budget = params[:budget].to_i
    if RedmineTocatApi.set_budget_for_issue(ticket, budget)
      render :status => 200
    else
      render :status => 406
    end
  end

  def set_order
  end
end
