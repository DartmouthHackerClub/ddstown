require 'base64'

class ReportsController < ApplicationController
  def index
    redirect_to :action => :new
  end

  def show
    @report = Report.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @report }
    end
  end

  def create
    puts "creating"
    @report = current_user.reports.build()
    @report.html = Base64.decode64(params[:transaction_history_html])
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
