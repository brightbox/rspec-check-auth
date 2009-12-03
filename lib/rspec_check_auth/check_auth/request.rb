class CheckAuth
  # Represents a single request spec
  # 
  # Format and Method should be a single symbol
  class Request
    attr_reader :action, :method, :params, :format

    def initialize action, format, params
      @action = action
      @format = format
      @method = params[:method] || default_method
      @params = params.except(:method)
    end

    # Adds the format into the params
    # unless it's HTML
    def params
      return @params.merge(:format => @format.to_s) unless @format == :html
      @params
    end

    # Works out the default method
    # for certain controller actions
    def default_method
      case @action.to_s
      when /create/
        :post
      when /update/
        :put
      when /destroy/
        :delete
      else# and when /(index|show|new|edit)/
        :get
      end
    end
  end
end