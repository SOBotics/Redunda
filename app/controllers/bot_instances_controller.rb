class BotInstancesController < ApplicationController
  before_action :set_bot_instance, only: [:show, :edit, :update, :destroy]

  def index
    @bot_instances = BotInstance.all
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

    respond_to do |format|
      if @bot_instance.save
        format.html { redirect_to @bot_instance, notice: 'Bot instance was successfully created.' }
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
        format.html { redirect_to @bot_instance, notice: 'Bot instance was successfully updated.' }
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

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_bot_instance
    @bot_instance = BotInstance.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def bot_instance_params
    params.require(:bot_instance).permit(:location)
  end
end
