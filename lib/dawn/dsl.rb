module Dawn
  module Dsl
    def config_directory
      @config_directory ||= Pathname.new(File.expand_path('~/.dawn')).tap(&:mkpath)
    end

    def log(flag, opts = {})
      data = log_file.exist? ? JSON.parse(log_file.read) : {}
      data[flag] ||= []
      data[flag].push(opts.merge(timestamp: Time.now.iso8601))
      File.open(log_file.to_s, 'w') { |f| f.write(data.to_json) }
    end

    private

    def log_file
      @log_file ||= config_directory.join(Pathname.new('log.json'))
    end
  end
end
