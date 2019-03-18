module Dawn
  class Input
    KEY = /\w+:(?<key>\w+)/.freeze
    INTERPOLATION = /(\${\w+:\w+})/.freeze

    attr_accessor :string

    def initialize(string)
      self.string = string
    end

    def interpolate(opts = {})
      return unless string
      interpolations = string.scan(INTERPOLATION).flatten
      string.dup.tap do |str|
        interpolations.each do |interpolation|
          key = interpolation.match(KEY)[:key]
          value = opts.fetch(key)
          str.sub!(interpolation, value)
        end
      end
    end
  end
end
