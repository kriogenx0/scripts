require 'webrick'
require 'irb'
require File.join(File.dirname(__FILE__), 'app.rb')

class AppServlet < WEBrick::HTTPServlet::AbstractServlet

  def do_GET(request, response)
    AppServer::process_request(request, response)
  end

end


class AppServer
  class << self

    attr_accessor :started

    @started = false

    SERVER_PORT = 1111

    def start(options = nil)

      if options.is_a? Hash
        App.load_options options
      end

      if App.settings[:console]
        start_console options
      else
        start_server options
      end

    end


    def process_request(request, response)
      puts '------------------------------'

      controller = MainController.new(request, response)

      #ActiveRecord::Base.clear_active_connections! if defined? ActiveRecord

      controller
    end


    def start_server(arguments = nil)
      @server = WEBrick::HTTPServer.new(:Port => SERVER_PORT)

      @server.mount "/", AppServlet

      trap("INT") {
        stop_server
      }

      @server.start
    end

    def start_console(arguments = nil)

      ARGV.clear if defined?(ARGV)
      IRB.start
    end

    def stop_server
      puts 'SHUTTING DOWN'
      @server.shutdown
    end

  end
end
