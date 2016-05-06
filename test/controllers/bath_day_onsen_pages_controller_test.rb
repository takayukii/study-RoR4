require 'test_helper'

class BathDayOnsenPagesControllerTest < ActionController::TestCase
  setup do
    @bath_day_onsen_page = bath_day_onsen_pages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bath_day_onsen_pages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bath_day_onsen_page" do
    assert_difference('BathDayOnsenPage.count') do
      post :create, bath_day_onsen_page: {  }
    end

    assert_redirected_to bath_day_onsen_page_path(assigns(:bath_day_onsen_page))
  end

  test "should show bath_day_onsen_page" do
    get :show, id: @bath_day_onsen_page
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bath_day_onsen_page
    assert_response :success
  end

  test "should update bath_day_onsen_page" do
    patch :update, id: @bath_day_onsen_page, bath_day_onsen_page: {  }
    assert_redirected_to bath_day_onsen_page_path(assigns(:bath_day_onsen_page))
  end

  test "should destroy bath_day_onsen_page" do
    assert_difference('BathDayOnsenPage.count', -1) do
      delete :destroy, id: @bath_day_onsen_page
    end

    assert_redirected_to bath_day_onsen_pages_path
  end
end
