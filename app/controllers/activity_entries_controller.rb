class ActivityEntriesController < ApplicationController
    before_action :require_login
  
    def new
      @activity_entry = ActivityEntry.new
      @data = ActivityDatum.all
    end
  
    def create
      weight_class = current_user.weight_class
      @activity = ActivityDatum.find_by(id: params[:activity_entry][:id])
      hours = params[:activity_entry][:minutes].to_f/60
      cals_burned = (@activity.cals_burned(weight_class, hours)).to_i
      @entry = ActivityEntry.new(name: @activity.name, minutes: params[:activity_entry][:minutes], activity_datum_id: params[:activity_entry][:id], user_id: @user.id)
      @entry.calories_burned = cals_burned
      if @entry.save
        render json: @entry, status: 201
      else
        redirect_to new_entry_path
      end
    end
  
    def edit
      @activity_entry = current_entry
    end
  

    def show
      @activity_entry = ActivityEntry.find_by_id(params[:id])
    end
  
    def destroy
      @current_entry = current_entry
      @current_entry.destroy
      flash[:success] = "Record successfully deleted!"
      redirect_to user_path(current_user)
    end
  
    private
    def current_entry
      ActivityEntry.find(params[:id])
    end
  
    def activity_entry_params
      params.require(:activity_entry).permit(:id, :minutes)
    end
  
  end