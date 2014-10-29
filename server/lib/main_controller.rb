require 'time'
require 'yaml'

class MainController < BaseController

  def index

    services = ['redis', 'apache', 'resque']



    template = File.join(PROJECT_ROOT, 'views', 'index.erb')
    if (File.exists?(template))
      file = File.open( template )
      template_contents = ERB.new( file.read )
      #puts file.read
      file.close
      render template_contents
    else
      render 'view not found'
    end

  end


end
