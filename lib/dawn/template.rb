module Dawn
  class Template
    attr_accessor :data, :name, :version, :parameters, :actions

    def initialize(opts = {})
      self.data = YAML.load_file(opts.fetch(:path))
      self.name = data.fetch('name')
      self.version = data.fetch('version')
    end

    def parameters
      @parameters ||= data.fetch('parameters') { [] }.map do |param|
        Parameter.new(
          name: param.fetch('name'),
          description: param.fetch('description'),
          type: param.fetch('type'),
          short: param.fetch('short'),
          long: param.fetch('long'),
          required: param['required']
        )
      end
    end

    def actions
      @actions ||= data.fetch('actions') { [] }.map do |action|
        Action.new(
          description: action['description'],
          type: action['type'],
          flag: action['flag'],
          # Shell
          up: action['up'],
          down: action['down'],
          test: action['test'],
          user: action['user'],
          # File
          content: action['content'],
          path: action['path'],
          permissions: action['permissions']
        )
      end
    end

    def execute!(opts = {})
      actions.each do |action|
        action.execute!(opts)
      end
    end
  end
end
