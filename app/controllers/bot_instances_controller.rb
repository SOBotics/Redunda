class BotInstancesController < ApplicationController
  protect_from_forgery except: :status_ping

  before_action :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy]
  before_action :set_bot_instance, only: [:show, :edit, :update, :destroy]
  before_action :set_bot, except: :status_ping
  before_action :check_instance_permissions, only: [:edit, :update, :destroy]
  before_action :check_bot_permissions, only: [:new, :create]

  def index
    @bot_instances = @bot.bot_instances
  end

  def show
  end

  def new
    @bot_instance = BotInstance.new
  end

  def edit
  end

  def create
    @bot_instance = BotInstance.new(bot_instance_params)
    @bot_instance.bot_id = params[:bot_id]
    @bot_instance.user = current_user

    respond_to do |format|
      if @bot_instance.save
        format.html { redirect_to url_for(:controller => :bot_instances, :action => :index, :bot_id => params[:bot_id]),
                                  notice: 'Bot instance was successfully created.' }
        format.json { render :show, status: :created, location: @bot_instance }
      else
        format.html { render :new }
        format.json { render json: @bot_instance.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @bot_instance.update(bot_instance_params)
        format.html { redirect_to url_for(:controller => :bot_instances, :action => :index, :bot_id => params[:bot_id]),
                                  notice: 'Bot instance was successfully updated.' }
        format.json { render :show, status: :ok, location: @bot_instance }
      else
        format.html { render :edit }
        format.json { render json: @bot_instance.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @bot_instance.destroy
    respond_to do |format|
      format.html { redirect_to bot_bot_instances_url(bot_id: params[:bot_id]), notice: 'Bot instance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def status_ping
    @bot_instance = BotInstance.where(key: params[:key]).first!
    @bot_instance.update(last_ping: DateTime.current)

    @bot = @bot_instance.bot

    ActionCable.server.broadcast "status_updates", { :bot_id => @bot.id, :instance_id => @bot_instance.id,
                                                     :ping => { :ago => ActionController::Base.helpers.time_ago_in_words(DateTime.current), :exact => DateTime.current },
                                                     :classes => { :status => @bot_instance.status_class, :panel => @bot_instance.panel_class }}
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_bot_instance
    @bot_instance = BotInstance.find(params[:id])
  end

  def set_bot
    @bot = Bot.find params[:bot_id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def bot_instance_params
    params.require(:bot_instance).permit(:location)
  end

  # Checks that a user has permissions (either owner of the bot or owner of the instance) on an instance.
  # Used before *modifying* an existing instance
  def check_instance_permissions
    unless @bot_instance.user_id == current_user.id || current_user.has_role?(:owner, @bot_instance.bot) || current_user.has_role?(:admin)
      render :status => :forbidden, :plain => "You're not allowed to modify this instance" and return
    end

    unless @bot_instance.bot_id.to_s == params[:bot_id]
      render :status => :forbidden, :plain => "This instance does not belong to this bot." and return
    end
  end

  # Checks that a user has permissions (either owner or collaborator) on a bot.
  # Used before *creating* a new instance
  def check_bot_permissions
    unless current_user.has_role? :owner, @bot || current_user.has_role?(:collaborator, @bot) || current_user.has_role?(:admin)
      render :status => :forbidden, :plain => "You're not allowed to create an instance on this bot" and return
    end
  end
end
