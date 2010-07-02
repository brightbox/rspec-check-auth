class CheckAuth
  # Represents a single request spec
  # 
  # Format and Method should be a single symbol
  class Request
    attr_reader :action, :method, :params, :format

    def initialize action, format, opts
      @action = action
      @format = format
      @method = opts[:method] || default_method
      self.params = opts.except(:method)
    end

    # Sets up the params hash
    # 
    # Adds :format => self.format if self.format != :html
    # Merges any passed params into default params for this action
    # 
    def params= param_hash
      @params = default_params.merge(param_hash)

      if @format == :html
        @params.delete(:format)
      else
        @params.merge!(:format => format.to_s)
      end
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

    # Adds an id for actions that require it
    def default_params
      case @action.to_s
      when /(show|edit|update|destroy)/
        {:id => "some_id"}
      else
        {}
      end
    end

  end
end