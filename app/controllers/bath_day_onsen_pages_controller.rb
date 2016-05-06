class BathDayOnsenPagesController < ApplicationController
  before_action :set_bath_day_onsen_page, only: [:show, :edit, :update, :destroy]

  # GET /bath_day_onsen_pages
  # GET /bath_day_onsen_pages.json
  def index
    @bath_day_onsen_pages = BathDayOnsenPage.all
  end

  # GET /bath_day_onsen_pages/1
  # GET /bath_day_onsen_pages/1.json
  def show
  end

  # GET /bath_day_onsen_pages/new
  def new
    @bath_day_onsen_page = BathDayOnsenPage.new
  end

  # GET /bath_day_onsen_pages/1/edit
  def edit
  end

  # POST /bath_day_onsen_pages
  # POST /bath_day_onsen_pages.json
  def create
    @bath_day_onsen_page = BathDayOnsenPage.new(bath_day_onsen_page_params)

    respond_to do |format|
      if @bath_day_onsen_page.save
        format.html { redirect_to @bath_day_onsen_page, notice: 'Bath day onsen page was successfully created.' }
        format.json { render :show, status: :created, location: @bath_day_onsen_page }
      else
        format.html { render :new }
        format.json { render json: @bath_day_onsen_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bath_day_onsen_pages/1
  # PATCH/PUT /bath_day_onsen_pages/1.json
  def update
    respond_to do |format|
      if @bath_day_onsen_page.update(bath_day_onsen_page_params)
        format.html { redirect_to @bath_day_onsen_page, notice: 'Bath day onsen page was successfully updated.' }
        format.json { render :show, status: :ok, location: @bath_day_onsen_page }
      else
        format.html { render :edit }
        format.json { render json: @bath_day_onsen_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bath_day_onsen_pages/1
  # DELETE /bath_day_onsen_pages/1.json
  def destroy
    @bath_day_onsen_page.destroy
    respond_to do |format|
      format.html { redirect_to bath_day_onsen_pages_url, notice: 'Bath day onsen page was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bath_day_onsen_page
      @bath_day_onsen_page = BathDayOnsenPage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bath_day_onsen_page_params
      params.fetch(:bath_day_onsen_page, {})
    end
end
