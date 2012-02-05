class ReportsController < ApplicationController
  def index
    redirect_to :action => :new
  end

  def show

  end

  def create
    puts "creating"
    @report = current_user.reports.build()
    @report.html = params[:transaction_history_html]
    @report.user = current_user
    if @report.save
      puts "it saved"
      @report.parse
      redirect_to :controller => :swipes, :action => :index
    else
      puts "it didn't save"
      render :action => :new
    end
  end

  def new
    @report = current_user.reports.build
  end
end
