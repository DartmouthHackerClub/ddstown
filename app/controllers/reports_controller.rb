require 'base64'

class ReportsController < ApplicationController
  def index
    redirect_to :action => :new
  end

  def show
    @report = Report.find(params[:id])
    @purchases = current_user.purchases
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @report }
    end
  end

  def create
    @report = current_user.reports.build()
    @report.html = params[:report][:html] || Base64.decode64(params[:report][:encoded_html])
    @report.user = current_user
    @report.source = params[:source] || "banner" # TODO: take out this default
    puts @report.source
    if @report.save
      puts "it saved"
      puts report.html
      @report.parse
      redirect_to "/users/#{current_user.id}"
    else
      puts "it didn't save"
      render :action => :new
    end
  end

  def new
    @report = current_user.reports.build
    @report.
  end
end
