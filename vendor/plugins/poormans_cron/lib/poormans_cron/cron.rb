module PoormansCron
  class Cron < ActiveRecord::Base
    set_table_name "poormans_crons"

    DEFAULT_WAIT_TIME = 60 * 60

    class << self
      def perform
        cron = nil

        now = Time.new
        cron = expired_cron(now)
        return unless cron

        begin
          cron.update_attributes(:performed_at => now, :in_progress  => true)
        rescue ActiveRecord::StaleObjectError
          return
        end

        begin
          cron.perform
        ensure
          cron.update_attributes(:in_progress => false) if cron
        end
      end

      def expired_cron(time)
        find(:all, :order => 'performed_at').select { |cron|
          if !cron.async || !cron.in_progress
            cron.performed_at.nil? || time > (cron.performed_at + cron.interval)
          else
            if cron.performed_at
              (time - cron.performed_at).to_i > (cron.wait_time || DEFAULT_WAIT_TIME)
            end
          end
        }.first
      end

      def jobs
        @jobs ||= {}
      end

      def register_job(name, &block)
        name = name.to_sym
        jobs[name] = [] unless jobs.key?(name)
        jobs[name] << block
      end
    end

    def perform
      logger.info "[poormans_cron] perform cron. name='#{name}'. pid=#{Process.pid}"
      if jobs = self.class.jobs[name.to_sym]
        jobs.each do |job|
          logger.info "[poormans_cron]   call job. #{job.inspect}"
          job.call
        end
      end
    end
  end
end
