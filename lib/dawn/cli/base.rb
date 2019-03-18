module Dawn
  module Cli
    class Base
      attr_accessor :argv

      def initialize(opts = {})
        self.argv = opts.fetch(:argv) { ARGV }
      end

      def execute!
        invalid! if argv.size < 2
        command = argv.shift
        case command
        when 'up'
          template = argv.shift
          Commands::Up.new(template_path: template).execute!
        when 'down'
          template = argv.shift
          Commands::Down.new(template_path: template).execute!
        else
          invalid!
        end
      end

      private

      def invalid!
        raise Exceptions::Invalid, 'usage: (up | down) TEMPLATE'
      end
    end
  end
end
