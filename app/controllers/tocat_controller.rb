class TocatController < ApplicationController
  unloadable


  def set_budget
    ticket = params[:ticket_id].to_i
    budget = params[:budget].to_i
    if RedmineTocatApi.set_budget_for_issue(ticket, budget)
      render :nothing => true, :status => 200
    else
      render :nothing => true, :status => 406
    end
  end

  def set_order
    ticket = params[:ticket_id].to_i
    order = ticket = params[:order_id].to_i
    if RedmineTocatApi.move_issue(ticket, order)
      render :nothing => true, :status => 200
    else
      render :nothing => true, :status => 406
    end
  end
end
