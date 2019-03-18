module Dawn
  class Action
    attr_accessor :description, :flag, :type, :up, :down, :test, :user, :content, :path, :permissions

    def initialize(opts = {})
      self.description = Input.new(opts.fetch(:description))
      self.flag = opts.fetch(:flag).downcase
      self.type = opts.fetch(:type).downcase
      # Shell
      self.up = Input.new(opts[:up])
      self.down = Input.new(opts[:down])
      self.test = Input.new(opts[:test])
      self.user = Input.new(opts[:user])
      # File
      self.content = Input.new(opts[:content])
      self.path = Input.new(opts[:path])
      self.permissions = opts[:permissions]
    end

    def execute!(opts = {})
      direction = opts.fetch(:direction)
      action(opts).execute!(direction: direction)
    end

    def action(opts = {})
      case type
      when 'shell'
        Dawn::Actions::Shell.new(
          description: description.interpolate(opts),
          flag: flag,
          up: up.interpolate(opts),
          down: down.interpolate(opts),
          test: test.interpolate(opts),
          user: user.interpolate(opts)
        )
      when 'file'
        Dawn::Actions::File.new(
          description: description.interpolate(opts),
          flag: flag,
          content: content.interpolate(opts),
          path: path.interpolate(opts),
          permissions: permissions
        )
      else
        raise NotImplementedError, "unknown type: #{type}"
      end
    end
  end
end
