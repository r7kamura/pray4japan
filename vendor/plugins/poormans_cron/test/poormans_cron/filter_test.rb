require 'test_helper'

class FilterTest < ActiveSupport::TestCase
  test 'should call PoormansCron.perform' do
    mock(Thread).start {|block| block.call}
    PoormansCron.filter {|controller| true }
    PoormansCron::Filter.filter('controller') {}
  end

  test 'should not call PoormansCron.perform when filterd' do
    mock(Thread).start.with_any_args.times(0)
    PoormansCron.filter {|controller| false }
    PoormansCron::Filter.filter('controller') {}
  end
end
