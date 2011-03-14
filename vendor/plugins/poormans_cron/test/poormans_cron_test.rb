require 'test_helper'

class ActionController::Base
  include PoormansCron
end

class MyController < ActionController::Base
  def index
    render :text => ''
  end

  def error
    raise 'error!'
  end
end

class PoormansCronTest < ActionController::TestCase
  def setup
    @controller = MyController.new
    stub(Thread).start { |block| block.call }
  end

  def test_for_filter
    mock(PoormansCron::Filter).filter(@controller) { true }
    get :index
  end

  def _test_for_skip_filter
    MyController.class_eval do
      skip_after_filter PoormansCron::Filter
    end
    mock(PoormansCron::Filter).filter(@controller).times(0)
    get :index
  end

  def test_for_filter_when_error
    mock(PoormansCron::Cron).perform.times(0)
    get :error
  end
end
