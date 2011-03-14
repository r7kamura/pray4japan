require 'test_helper'

class CronTest < ActiveSupport::TestCase
  context 'a cron is exists' do
    setup do
      PoormansCron::Cron.delete_all
      @cron = PoormansCron::Cron.create!(:name => 'foo', :interval => 60)
      @now = Time.now
      stub(Time).now { @now }
    end

    context '2 crons' do
      setup do
        @other_cron = PoormansCron::Cron.create!(:name => 'bar', :interval => 60)
        @cron.update_attribute(:in_progress, false)
        @other_cron.update_attribute(:in_progress, false)
      end

      should 'get expired_cron order by performed_at' do
        @cron.update_attribute(:performed_at, @now - 100)
        @other_cron.update_attribute(:performed_at, @now - 101)
        PoormansCron::Cron.expired_cron(@now)
        assert_equal @other_cron, PoormansCron::Cron.expired_cron(@now)
        @other_cron.update_attribute(:performed_at, @now - 99)
        assert_equal @cron, PoormansCron::Cron.expired_cron(@now)
      end
    end

    context 'performed_at is nil and in_progress is true' do
      setup do
        @cron.update_attributes(:performed_at => nil, :in_progress => true)
      end

      context 'async is false' do
        setup do
          @cron.update_attributes(:async => false)
        end

        should 'get expired_cron' do
          assert_not_nil PoormansCron::Cron.expired_cron(@now)
        end
      end

      context 'async is true' do
        setup do
          @cron.update_attributes(:async => true)
        end

        should 'get no expired_cron' do
          assert_nil PoormansCron::Cron.expired_cron(@now)
        end
      end
    end

    context 'performed_at is nil and in_progress is false' do
      setup do
        @cron.update_attributes(:performed_at => nil, :in_progress => false)
      end

      should 'get expired_cron' do
        assert_not_nil PoormansCron::Cron.expired_cron(@now)
      end

      should 'called perform' do
        mock(PoormansCron::Cron).expired_cron.with_any_args.times(1) { @cron }
        mock(@cron).perform.times(1) {}
        PoormansCron::Cron.perform
      end

      context 'a job was registered' do
        setup do
          @block = lambda {}
          PoormansCron::Cron.register_job(:foo, &@block)
          stub(Thread).start.with_any_args { |block| block.call }
        end

        should 'a job was registered' do
          assert PoormansCron::Cron.jobs[:foo].include?(@block)
        end

        should 'called perform' do
          mock(@block).call.times(1) {}
          PoormansCron::Cron.perform
        end
      end

      context 'jobs was registered' do
        setup do
          @block1 = lambda {}
          PoormansCron::Cron.register_job(:foo, &@block1)
          @block2 = lambda {}
          PoormansCron::Cron.register_job(:foo, &@block2)
        end

        should 'called perform' do
          mock(@block1).call.times(1) {}
          mock(@block2).call.times(1) {}
          PoormansCron::Cron.perform
        end
      end
    end

    context 'performed_at is now' do
      setup do
        @cron.update_attribute(:performed_at, @now)
      end

      should 'get no expired_cron' do
        assert_nil PoormansCron::Cron.expired_cron(@now)
      end
    end

    context 'set wait_time' do
      setup do
        @cron.wait_time = 60 * 30
      end

      context 'set @cron.performed_at to expire' do
        setup do
          @cron.update_attribute(
            :performed_at,
            Time.now - @cron.wait_time - 1
          )
        end

        should 'return expired cron' do
          assert_not_nil PoormansCron::Cron.expired_cron(@now)
        end
      end
    end
  end
end
