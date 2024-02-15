require 'test_helper'

class TimersControllerTest < ActionDispatch::IntegrationTest
  test 'should get new' do
    get timers_new_url
    assert_response :success
  end
end
