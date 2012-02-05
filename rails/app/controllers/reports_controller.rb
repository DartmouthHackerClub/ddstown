class ReportsController < ApplicationController
  def index
    redirect_to :action => :new
  end

  def show

  end

  def create
    @report = current_user.reports.build(params[:report])
    @report.user = current_user
    if @report.save
      @report.parse
      redirect_to :controller => :swipes, :action => :index
    else
      render :action => :new
    end
  end

  def new
    @report = current_user.reports.build
  end
end
