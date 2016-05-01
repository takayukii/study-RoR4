class WikipediaPagesController < ApplicationController
  before_action :set_wikipedia_page, only: [:show, :edit, :update, :destroy]

  # GET /wikipedia_pages
  # GET /wikipedia_pages.json
  def index
    @wikipedia_pages = WikipediaPage.all
  end

  # GET /wikipedia_pages/1
  # GET /wikipedia_pages/1.json
  def show
  end

  # GET /wikipedia_pages/new
  def new
    @wikipedia_page = WikipediaPage.new
  end

  # GET /wikipedia_pages/1/edit
  def edit
  end

  # POST /wikipedia_pages
  # POST /wikipedia_pages.json
  def create
    @wikipedia_page = WikipediaPage.new(wikipedia_page_params)

    respond_to do |format|
      if @wikipedia_page.save
        format.html { redirect_to @wikipedia_page, notice: 'Wikipedia page was successfully created.' }
        format.json { render :show, status: :created, location: @wikipedia_page }
      else
        format.html { render :new }
        format.json { render json: @wikipedia_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wikipedia_pages/1
  # PATCH/PUT /wikipedia_pages/1.json
  def update
    respond_to do |format|
      if @wikipedia_page.update(wikipedia_page_params)
        format.html { redirect_to @wikipedia_page, notice: 'Wikipedia page was successfully updated.' }
        format.json { render :show, status: :ok, location: @wikipedia_page }
      else
        format.html { render :edit }
        format.json { render json: @wikipedia_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wikipedia_pages/1
  # DELETE /wikipedia_pages/1.json
  def destroy
    @wikipedia_page.destroy
    respond_to do |format|
      format.html { redirect_to wikipedia_pages_url, notice: 'Wikipedia page was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wikipedia_page
      @wikipedia_page = WikipediaPage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wikipedia_page_params
      params.fetch(:wikipedia_page, {})
    end
end
