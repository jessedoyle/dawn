module Dawn
  module Cli
    module Commands
      class Down
        attr_accessor :template

        def initialize(opts = {})
          self.template = Dawn::Template.new(path: opts.fetch(:template_path))
        end

        def execute!
          parameters = {}
          OptionParser.new do |opts|
            opts.banner = usage_banner
            template.parameters.each do |param|
              opts.on(param.short, param.long, param.description) do |value|
                parameters[param.name] = value
              end
            end
          end.parse!
          validate_parameters!(parameters)
          template.execute!(parameters.merge(direction: :down))
        end

        private

        def validate_parameters!(params)
          template.parameters.select(&:required).each do |param|
            missing_parameter! unless params[param.name]
          end
        end

        def missing_parameter!
          raise Exceptions::MissingParameter, usage_banner
        end

        def usage_banner
          "usage: dawn down TEMPLATE #{long_parameters}"
        end

        def long_parameters
          template.parameters.map(&:long).join(' ')
        end
      end
    end
  end
end
