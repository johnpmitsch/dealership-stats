class CarsController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    if params.has_key?(:start_date) && params.has_key?(:end_date)
      @cars = Car.where(:date_sold => params[:start_date]..params[:end_date])
    else
      @cars = Car.all.order(sort_column + " " + sort_direction)
    end
  end

  def new
    @car = Car.new
  end

  def create
    @car = Car.new(car_params)
    if @car.save
      redirect_to 'index'
    else
      render 'new'
    end
  end

  private

  def car_params
    params.require(:car).permit(:year, :make, :model, :price, :date_sold)
  end

  def sort_column
    p params[:sort]
    p %w[year make model price date_sold].include?(params[:sort])
    %w[year make model price date_sold].include?(params[:sort]) ? params[:sort] : "date_sold"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
