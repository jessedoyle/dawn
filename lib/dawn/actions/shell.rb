module Dawn
  module Actions
    class Shell
      OPTIONAL_PARAMETERS = %i[
        user
      ].freeze
      REQUIRED_PARAMETERS = %i[
        description
        flag
        up
        down
        test
      ].freeze
      PARAMETERS = (OPTIONAL_PARAMETERS | REQUIRED_PARAMETERS).freeze

      attr_accessor(*PARAMETERS)

      def initialize(opts = {})
        validate!(opts)
        self.description = opts.fetch(:description)
        self.flag = opts.fetch(:flag)
        self.up = opts.fetch(:up)
        self.down = opts.fetch(:down)
        self.test = opts.fetch(:test)
        self.user = opts[:user]
      end

      def execute!(opts = {})
        direction = opts.fetch(:direction) { :up }
        puts "\n=== #{description} | #{direction.capitalize} ==="
        as_user do |test_command, up_command, down_command|
          present = shell(test_command, throw: false).success?
          if direction == :up
            if present
              puts "action:skip  -- #{up}\n"
            else
              shell(up_command)
            end
          else
            if present
              shell(down_command)
            else
              puts "action:skip  -- #{down}\n"
            end
          end
        end
      end

      private

      def validate!(params)
        REQUIRED_PARAMETERS.each do |param|
          blank = param.nil? || param.empty?
          raise Exceptions::MissingParameter, "invalid parameter #{param}" if blank
        end
      end

      def as_user
        if user
          test_command = "sudo -u #{user} #{test}"
          up_command = "sudo -u #{user} #{up}"
          down_command = "sudo -u #{user} #{down}"
          yield(test_command, up_command, down_command)
        else
          yield(test, up, down)
        end
      end

      def shell(command, opts = {})
        puts "action:shell -- #{command}"
        throw = opts.fetch(:throw) { true }
        stdout, stderr, status = Open3.capture3(command)
        data = {
          command: command,
          stdout: stdout,
          stderr: stderr,
          status: status.exitstatus
        }
        Dawn.log(flag, data)
        raise Exceptions::CommandFailed, JSON.pretty_generate(data) if !status.success? && throw

        status
      end
    end
  end
end
