class PlayoffsController < ApplicationController
  before_action :set_playoff, only: [:show, :edit, :update, :destroy]

  # GET /playoffs
  # GET /playoffs.json
  def index
    if(params[:mode] != nil && params[:mode] == "run")
      render :json => Playoff.exists?(:running => true)
    elsif(params[:running] != nil && params[:running])
      @playoffs = Playoff.where(running: true)
    else
      @playoffs = Playoff.all
    end

  end

  # GET /playoffs/1
  # GET /playoffs/1.json
  def show
  end

  # GET /playoffs/new
  def new
    @playoff = Playoff.new
  end

  # GET /playoffs/1/edit
  def edit
  end

  # POST /playoffs
  # POST /playoffs.json
  def create
    @playoff = Playoff.new(playoff_params)

    respond_to do |format|
      if @playoff.save
        format.html { redirect_to @playoff, notice: 'Playoff was successfully created.' }
        format.json { render :show, status: :created, location: @playoff }
      else
        format.html { render :new }
        format.json { render json: @playoff.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /playoffs/1
  # PATCH/PUT /playoffs/1.json
  def update
    respond_to do |format|
      if @playoff.update(playoff_params)
        format.html { redirect_to @playoff, notice: 'Playoff was successfully updated.' }
        format.json { render :show, status: :ok, location: @playoff }
      else
        format.html { render :edit }
        format.json { render json: @playoff.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /playoffs/1
  # DELETE /playoffs/1.json
  def destroy
    @playoff.destroy
    respond_to do |format|
      format.html { redirect_to playoffs_url, notice: 'Playoff was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_playoff
      @playoff = Playoff.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def playoff_params
      params.require(:playoff).permit(:team1, :team2, :title, :running, :g1, :g2, :g3, :g4, :g5, :g6, :g7)
    end
end
