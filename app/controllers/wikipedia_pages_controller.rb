class WikipediaPagesController < ApplicationController
  def index
    @pages = WikipediaPage.all
  end
end
