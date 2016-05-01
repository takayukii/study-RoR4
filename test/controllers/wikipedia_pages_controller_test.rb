require 'test_helper'

class WikipediaPagesControllerTest < ActionController::TestCase
  setup do
    @wikipedia_page = wikipedia_pages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:wikipedia_pages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create wikipedia_page" do
    assert_difference('WikipediaPage.count') do
      post :create, wikipedia_page: {  }
    end

    assert_redirected_to wikipedia_page_path(assigns(:wikipedia_page))
  end

  test "should show wikipedia_page" do
    get :show, id: @wikipedia_page
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @wikipedia_page
    assert_response :success
  end

  test "should update wikipedia_page" do
    patch :update, id: @wikipedia_page, wikipedia_page: {  }
    assert_redirected_to wikipedia_page_path(assigns(:wikipedia_page))
  end

  test "should destroy wikipedia_page" do
    assert_difference('WikipediaPage.count', -1) do
      delete :destroy, id: @wikipedia_page
    end

    assert_redirected_to wikipedia_pages_path
  end
end
