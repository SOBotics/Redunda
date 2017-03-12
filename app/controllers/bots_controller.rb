class BotsController < ApplicationController
  before_action :set_bot, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :check_bot_ownership, only: [:edit, :update, :destroy]

  # GET /bots
  # GET /bots.json
  def index
    @bots = Bot.all
  end

  # GET /bots/1
  # GET /bots/1.json
  def show
  end

  # GET /bots/new
  def new
    @bot = Bot.new
  end

  # GET /bots/1/edit
  def edit
  end

  # POST /bots
  # POST /bots.json
  def create
    @bot = Bot.new(bot_params)

    respond_to do |format|
      if @bot.save
        current_user.add_role :owner, @bot

        format.html { redirect_to bots_path, flash: { success: 'Bot was successfully created.' } }
        format.json { render :show, status: :created, location: @bot }
        else
        format.html { render :new }
        format.json { render json: @bot.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bots/1
  # PATCH/PUT /bots/1.json
  def update
    respond_to do |format|
      if @bot.update(bot_params)
        format.html { redirect_to bots_path, flash: { success: 'Bot was successfully updated.' } }
        format.json { render :show, status: :ok, location: @bot }
        else
        format.html { render :edit }
        format.json { render json: @bot.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bots/1
  # DELETE /bots/1.json
  def destroy
    @bot.destroy
    respond_to do |format|
      format.html { redirect_to bots_path, flash: { success: 'Bot was successfully destroyed.' } }
      format.json { head :no_content }
    end
  end


  # POST /bots/1/collaborators
  # POST /bots/1/collaborators.json
  def add_collaborator
    @bot = Bot.find(params[:bot])

    unless User.exists?(id: params[:collaborator])
      respond_to do |format|
        format.html { redirect_to edit_bot_path(@bot), flash: { error: 'That user ID does not exist.' } }
        format.json { render json: 'That user ID does not exist.', status: :not_found }
      end
      return
    end

    @collaborator = User.find(params[:collaborator])

    if @collaborator.has_role?(:collaborator, @bot)
      respond_to do |format|
        format.html { redirect_to edit_bot_path(@bot), flash: { error: 'That user is already a collaborator.' } }
        format.json { render json: 'That user is already a collaborator.', status: :unprocessable_entity }
      end
      return
    end

    @collaborator.add_role :collaborator, @bot

    respond_to do |format|
      format.html { redirect_to edit_bot_path(@bot), flash: { success: 'Collaborator was successfully added.' } }
      format.js   { }
      format.json { head :no_content }
    end
  end



  def remove_collaborator
    @bot = Bot.find(params[:bot])
    @collaborator = User.find(params[:collaborator])

    unless @collaborator.has_role?(:collaborator, @bot)
      respond_to do |format|
        format.html { redirect_to edit_bot_path(@bot), flash: { error: 'That user is not a collaborator.' } }
        format.json { render json: 'That user is not a collaborator.', status: :unprocessable_entity }
      end
      return
    end

    @collaborator.remove_role :collaborator, @bot

    respond_to do |format|
      format.html { redirect_to edit_bot_path(@bot), flash: { success: 'Collaborator was successfully removed.' } }
      format.js   { }
      format.json { head :no_content }
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_bot
    @bot = Bot.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def bot_params
    params.require(:bot).permit(:name, :description)
  end

  def check_bot_ownership
    unless current_user.has_role? :owner, @bot || current_user.has_role?(:admin)
      render :status => :forbidden, :plain => "You don't own this bot" and return
    end
  end
end
