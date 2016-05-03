require 'test_helper'

class MichinoekiWikipediaPagesControllerTest < ActionController::TestCase
  setup do
    @michinoeki_wikipedia_page = michinoeki_wikipedia_pages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:michinoeki_wikipedia_pages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create michinoeki_wikipedia_page" do
    assert_difference('MichinoekiWikipediaPage.count') do
      post :create, michinoeki_wikipedia_page: {  }
    end

    assert_redirected_to michinoeki_wikipedia_page_path(assigns(:michinoeki_wikipedia_page))
  end

  test "should show michinoeki_wikipedia_page" do
    get :show, id: @michinoeki_wikipedia_page
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @michinoeki_wikipedia_page
    assert_response :success
  end

  test "should update michinoeki_wikipedia_page" do
    patch :update, id: @michinoeki_wikipedia_page, michinoeki_wikipedia_page: {  }
    assert_redirected_to michinoeki_wikipedia_page_path(assigns(:michinoeki_wikipedia_page))
  end

  test "should destroy michinoeki_wikipedia_page" do
    assert_difference('MichinoekiWikipediaPage.count', -1) do
      delete :destroy, id: @michinoeki_wikipedia_page
    end

    assert_redirected_to michinoeki_wikipedia_pages_path
  end
end
