module PoormansCron
  module Filter
    class << self
      def filter(controller)
        return if PoormansCron.filter_proc && !PoormansCron.filter_proc.call(controller)

        Thread.start do
          begin
            PoormansCron::Cron.perform
          rescue Exception => e
            Rails.logger.error "[poormans_cron] #{e}\n#{e.backtrace.join("\n")}"
          end
        end
      end
    end
  end
end
