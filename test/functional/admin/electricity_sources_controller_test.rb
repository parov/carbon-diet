require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/electricity_sources_controller'

# Re-raise errors caught by the controller.
class Admin::ElectricitySourcesController; def rescue_action(e) raise e end; end

class Admin::ElectricitySourcesControllerTest < Test::Unit::TestCase
  fixtures :electricity_sources

  def setup
    @controller = Admin::ElectricitySourcesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index_access
    get :index
    assert_response 401 # Access denied
  end

  def test_list_access
    get :list
    assert_response 401 # Access denied
  end

  def test_edit_access
    get :edit, :id => 1
    assert_response 401 # Access denied
  end

  def test_destroy_access
    get :destroy, :id => 1
    assert_response 401 # Access denied
  end

end