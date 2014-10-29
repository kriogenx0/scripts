class BaseController

  attr_accessor :body, :response, :request, :query

  def initialize(request = nil, response = nil)
    @request = request
    @response = response
    if defined?(request.query)
      @query = {}
      request.query.each do |key, value|
        @query[key.is_a?(Fixnum) ? key.to_i : key.to_sym] = value.to_s
      end
    end

    @response.status = 500

    run_action request.path
  end

  def params
    @query
  end

  def run_action(action_name)
    # Remove starting and trailing slashes
    action_name = action_name.to_s.gsub(/(^\/)|(\/$)/,'')

    if !action_name.empty? && respond_to?(action_name)
      send(action_name)
    elsif respond_to?(:index)
      send(:index)
    elsif respond_to?(:default)
      send(:default)
    else
      puts "ACTION NOT FOUND - #{action_name.empty? ? '-EMPTY-' : action_name.to_s}"
    end
  end

  def render(content, content_type = :html, status = 200)
    set_content_type content_type
    set_status status
    @response.body = content
  end

  def set_content_type(content_type = :html)
    content_type = content_type.to_sym
    if content_type == :json
      @response.content_type = 'text/json'
    else
      @response.content_type = 'text/html'
    end
  end

  def set_status(status_code = 200)
    @response.status = status_code
  end

end
