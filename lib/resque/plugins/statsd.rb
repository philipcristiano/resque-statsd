module Resque
  module Plugins
    module Statsd

      def after_enqueue_statsd(*args)
        $resque_statsd.increment("#{@queue}.#{self}.enqueued")
        $resque_statsd.increment("total.enqueued")
      end

      def before_perform_statsd(*args)
        $resque_statsd.increment("#{@queue}.#{self}.started")
        $resque_statsd.increment("total.started")
      end

      def after_perform_statsd(*args)
        $resque_statsd.increment("#{@queue}.#{self}.finished")
        $resque_statsd.increment("total.finished")
      end

      def on_failure_statsd(*args)
        $resque_statsd.increment("#{@queue}.#{self}.failed")
        $resque_statsd.increment("total.failed")
      end

      def around_perform_statsd(*args)
        timing = Benchmark.measure { yield }
        $resque_statsd.timing("#{@queue}.#{self}.processed", (timing.real * 1000.0).round)
      end

    end
  end
end


