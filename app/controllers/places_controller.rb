class PlacesController < ApplicationController
  before_action :set_place, only: %i[ show edit update destroy]

  # GET /places or /places.json
  def index
  
  end

  # GET /places/1 or /places/1.json
  def show
    @place = Place.find( params[:id])
    @user = @place.user
  end

  # GET /places/new
  def new
    @place = Place.new
  end

  # GET /places/1/edit
  def edit
  end

  # POST /places or /places.json
  def create
    @place = current_user.places.new(place_params)

    respond_to do |format|
      if @place.save
        format.html { redirect_to place_url(@place), notice: t("Place_was_successfully_created") }
        format.json { render :show, status: :created, location: @place }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /places/1 or /places/1.json
  def update
    respond_to do |format|
      if @place.update(place_params)
        format.html { redirect_to place_url(@place), notice: t("Place_was_successfully_updated") }
        format.json { render :show, status: :ok, location: @place }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /places/1 or /places/1.json
  def destroy
    @place.destroy

    respond_to do |format|
      format.html { redirect_to user_places_path(current_user), notice: t("Place_was_successfully_destroyed") }
      format.json { head :no_content }
    end
    
  end

  def user_places
    
    @user = User.find_by(id: params[:id] )
    @places =  @user.places
    render 'places/index'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_place
      @place = Place.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def place_params
      params.require(:place).permit(:name, :latitude, :longitude)
    end
end
