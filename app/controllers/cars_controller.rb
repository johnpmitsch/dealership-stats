class CarsController < ApplicationController
  helper_method :sort_column, :sort_direction, :price_total_per_month, :car_arrays

  def index
    p 'index \n'
    if params.has_key?(:start_date) && params.has_key?(:end_date)
      @cars = Car.where(:date_sold => params[:start_date]..params[:end_date])
    else
      @cars = Car.all.order(sort_column + " " + sort_direction)
    end
    @dates, @prices = price_total_per_month
    @car_arrays = models_sold_per_month
    @total_models_sold = total_models_sold
    p @total_models_sold
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

  def show
    p 'show \n'
    @car = Car.find(params[:id])
  end

  def edit
    p 'edit \n'
    @car = Car.find(params[:id])
  end

  def update
    p 'update \n'
    @car = Car.find(params[:id])
    @car.update!(car_params)
    redirect_to @car
  end

  def delete
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

  def price_total_per_month
    dates = []
    prices = []
    min_year = Car.minimum("date_sold").strftime('%Y')
    max_year = Date.today.strftime("%Y")
    (min_year..max_year).each do |year|
      cars_by_year = Car.where("strftime('%Y', date_sold) + 0 = ?", year.to_i)
      (1..12).each do |month|
        cars_by_month = cars_by_year.where("strftime('%m', date_sold) + 0 = ?", month.to_i)
        price_by_month = cars_by_month.sum :price
        next if price_by_month == 0
        prices << price_by_month
        date = Time.new(year.to_i, month).to_f * 1000
        dates << date
      end
    end
    return dates, prices
  end

  def models_sold_per_month
    """Gets the number of cars sold each month by each model of car. Returns an
    array of arrays"""
    car_models = get_car_models
    min_year, max_year = min_max_year
    car_arrays = []
    car_models.each do |model|
      sales_per_model = [model]  # store model name as 0 index in array for c3 chart reference
      (min_year..max_year).each do |year|
        (1..12).each do |month|
          cars_by_month = Car.where("strftime('%m', date_sold) + 0 = ?", month.to_i).
                              where("strftime('%Y', date_sold) + 0 = ?", year.to_i)
          if cars_by_month.length > 0
            car_count_by_model= cars_by_month.where(model: model).count
            sales_per_model << car_count_by_model
          end
        end
      end
      car_arrays << sales_per_model
    end
    return car_arrays
  end

  def total_models_sold
    """Gets the number of models sold per model. Returns an array of arrays"""
    car_models = get_car_models
    car_arrays = []
    car_models.each do |model|
      sales_per_model = [model, Car.where(model: model).count]
      car_arrays << sales_per_model
    end
    return car_arrays
  end

  def min_max_year
    min_year = Car.minimum("date_sold").strftime('%Y')
    max_year = Date.today.strftime("%Y")
    return min_year, max_year
  end

  def get_car_models
    car_models = []
    Car.select(:model).distinct.each do |car|
      car_models << car.model
    end
    return car_models
  end
end
