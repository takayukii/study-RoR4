class MichinoekiWikipediaPagesController < ApplicationController
  before_action :set_michinoeki_wikipedia_page, only: [:show, :edit, :update, :destroy]

  # GET /michinoeki_wikipedia_pages
  # GET /michinoeki_wikipedia_pages.json
  def index
    @michinoeki_wikipedia_pages = MichinoekiWikipediaPage.all
  end

  # GET /michinoeki_wikipedia_pages/1
  # GET /michinoeki_wikipedia_pages/1.json
  def show
    lat = @michinoeki_wikipedia_page.latitude
    lng = @michinoeki_wikipedia_page.longitude
    @bath_day_onsen_pages = BathDayOnsenPage.near([lat, lng], 10, :units => :km)
  end

  # GET /michinoeki_wikipedia_pages/new
  def new
    @michinoeki_wikipedia_page = MichinoekiWikipediaPage.new
  end

  # GET /michinoeki_wikipedia_pages/1/edit
  def edit
  end

  # POST /michinoeki_wikipedia_pages
  # POST /michinoeki_wikipedia_pages.json
  def create
    @michinoeki_wikipedia_page = MichinoekiWikipediaPage.new(michinoeki_wikipedia_page_params)

    respond_to do |format|
      if @michinoeki_wikipedia_page.save
        format.html { redirect_to @michinoeki_wikipedia_page, notice: 'Michinoeki wikipedia page was successfully created.' }
        format.json { render :show, status: :created, location: @michinoeki_wikipedia_page }
      else
        format.html { render :new }
        format.json { render json: @michinoeki_wikipedia_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /michinoeki_wikipedia_pages/1
  # PATCH/PUT /michinoeki_wikipedia_pages/1.json
  def update
    respond_to do |format|
      if @michinoeki_wikipedia_page.update(michinoeki_wikipedia_page_params)
        format.html { redirect_to @michinoeki_wikipedia_page, notice: 'Michinoeki wikipedia page was successfully updated.' }
        format.json { render :show, status: :ok, location: @michinoeki_wikipedia_page }
      else
        format.html { render :edit }
        format.json { render json: @michinoeki_wikipedia_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /michinoeki_wikipedia_pages/1
  # DELETE /michinoeki_wikipedia_pages/1.json
  def destroy
    @michinoeki_wikipedia_page.destroy
    respond_to do |format|
      format.html { redirect_to michinoeki_wikipedia_pages_url, notice: 'Michinoeki wikipedia page was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_michinoeki_wikipedia_page
      @michinoeki_wikipedia_page = MichinoekiWikipediaPage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def michinoeki_wikipedia_page_params
      params.fetch(:michinoeki_wikipedia_page, {})
    end
end
