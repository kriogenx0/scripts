class App
  class << self

    attr_accessor :environment, :root, :client
    attr_accessor :logger
    attr_accessor :started
    attr_accessor :settings

    @environment = nil
    @client = 'pd'
    @started = false

    def env(environment = nil)
      if !environment.nil?
        load_environment environment
      else
        @environment
      end
    end

    def production?
      self.env == :production
    end

    def load_environment(options = nil)
      env_name = nil

      # Parse options
      if options.is_a? Array

        if options.delete 'testing'
          env_name = 'testing'
        elsif options.delete 'staging'
          env_name = 'staging'
        elsif options.delete 'production'
          env_name = 'production'
        elsif options.delete 'development'
          env_name = 'development'
        end

      end

      if env_name.nil? || env_name.to_s.empty?

        env_name = if options.is_a? Array
          options[0]
        elsif !options.nil?
          options.to_s
        elsif defined?(ENV['RAILS_ENV'])
          ENV['RAILS_ENV']
        elsif defined?(Env)
          Env.is_production? ? 'production' : 'development'
        end

      end

      if !env_name || env_name.to_s.empty?
        env_name = 'development'
      elsif env_name === true
        env_name = 'production'
      end

      @environment = env_name.to_s
      ENV['RAILS_ENV'] = @environment

      @environment
    end

    def start(options = nil)
      load_options options

      return if @started

      puts "STARTING APP IN - #{@environment}"
      @started = true
    end

    def load_options(options = nil)
      @settings ||= {}
      if options.is_a? Array
        @settings[:console] = options.delete('console')
      end
      load_environment options
    end

  end
end
