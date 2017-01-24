require 'test_helper'

class PlayoffsControllerTest < ActionController::TestCase
  setup do
    @playoff = playoffs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:playoffs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create playoff" do
    assert_difference('Playoff.count') do
      post :create, playoff: { g1: @playoff.g1, g2: @playoff.g2, g3: @playoff.g3, g4: @playoff.g4, g5: @playoff.g5, g6: @playoff.g6, g7: @playoff.g7, running: @playoff.running, team1: @playoff.team1, team2: @playoff.team2, title: @playoff.title }
    end

    assert_redirected_to playoff_path(assigns(:playoff))
  end

  test "should show playoff" do
    get :show, id: @playoff
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @playoff
    assert_response :success
  end

  test "should update playoff" do
    patch :update, id: @playoff, playoff: { g1: @playoff.g1, g2: @playoff.g2, g3: @playoff.g3, g4: @playoff.g4, g5: @playoff.g5, g6: @playoff.g6, g7: @playoff.g7, running: @playoff.running, team1: @playoff.team1, team2: @playoff.team2, title: @playoff.title }
    assert_redirected_to playoff_path(assigns(:playoff))
  end

  test "should destroy playoff" do
    assert_difference('Playoff.count', -1) do
      delete :destroy, id: @playoff
    end

    assert_redirected_to playoffs_path
  end
end
