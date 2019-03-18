module Dawn
  class Parameter
    attr_accessor :name, :type, :short, :long, :description, :required

    def initialize(opts = {})
      self.name = opts.fetch(:name)
      self.description = opts.fetch(:description)
      self.type = opts.fetch(:type)
      self.short = opts.fetch(:short)
      self.long = opts.fetch(:long)
      self.required = opts.fetch(:required) { false }
    end

    def missing?(value)
      value && value.empty?
    end
  end
end
