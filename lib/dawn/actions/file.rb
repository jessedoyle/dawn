module Dawn
  module Actions
    class File
      OPTIONAL_PARAMETERS = %i[
        permissions
      ].freeze
      REQUIRED_PARAMETERS = %i[
        description
        flag
        content
        path
      ].freeze
      PARAMETERS = (OPTIONAL_PARAMETERS | REQUIRED_PARAMETERS).freeze
      
      attr_accessor(*PARAMETERS)

      def initialize(opts = {})
        validate!(opts)
        self.description = opts.fetch(:description)
        self.flag = opts.fetch(:flag)
        self.content = opts.fetch(:content)
        self.path = opts.fetch(:path)
        self.permissions = opts.fetch(:permissions) { 0400 }
      end

      def execute!(opts = {})
        direction = opts.fetch(:direction) { :up }
        exists = pathname.exist?
        puts "=== #{description} | #{direction.capitalize}"
        if direction == :up
          if exists
            puts "action:skip -- #{pathname.to_s} exists"
          else
            # we could get fancy and check if the content is identical, but that's more
            # work than needed for a proof-of-concept
            puts "action:file -- create #{pathname.to_s}"
            ::File.open(pathname.to_s, 'w', permissions) { |f| f.write(content) }
            Dawn.log(flag, file: { path: pathname.to_s, action: 'create', permissions: permissions })
          end
        else
          if exists
            puts "action:file -- delete #{pathname.to_s}" 
            FileUtils.rm(pathname.to_s)
            Dawn.log(flag, file: { path: pathname.to_s, action: 'delete' })
          else
            puts "action:skip -- #{pathname.to_s} does not exist"
          end
        end
      end

      private

      def pathname
        @pathname ||= Pathname.new(::File.expand_path(path))
      end

      def validate!(params)
        REQUIRED_PARAMETERS.each do |param|
          blank = param.nil? || param.empty?
          raise Exceptions::MissingParameter, "invalid parameter #{param}" if blank
        end
      end
    end
  end
end