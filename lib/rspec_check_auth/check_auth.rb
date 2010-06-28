class CheckAuth

  def initialize
    @store = {}
  end

  # The main method
  def self.for &block
    instance = self.new
    block.call(instance)
    instance.output
  end

  # Handles checking 
  @@block = nil
  def self.checking_block format=nil, &block
    if block
      @@block = block
    else
      raise "CheckAuth#checking_block needs defining" unless @@block
      @@block.call(format)
    end
  end

  def add action, params={}
    params[:format] = [:html, :xml] unless params.has_key?(:format)
    params[:format].arrayize.each do |format|
      @store[format] ||= []
      r = Request.new(action, format, params.except(:format))
      @store[format] << r
    end
  end

  # 
  # Tests all the standard methods a resources route has.
  # Any params given (other than :except) are passed to each action as params,
  # and actions that require an id (edit, show, update) get passed "some_id"
  # 
  # Accepts:
  #   :only => [:action, :names]
  #   :except => [:action, :names]
  # 
  # Either param can be a single action, or an array of actions. :only takes precedence over :except.
  # 
  def resource_actions params={}
    except = params.delete(:except).arrayize.compact
    only = params.delete(:only).arrayize.compact

    params[:format] = params.has_key?(:format) ? params[:format].arrayize : [:html,:xml]

    # Logic to see if we should add an action
    # It should either be in :only, or :except isn't empty and it's not in :except
    should_add = lambda do |action|
      # Only isn't empty and our action is contained within
      if !only.empty?
        break only.include?(action)
      end
      # Except isn't empty and our action isn't contained therein
      if !except.empty?
        break !except.include?(action)
      end
      # Just add it
      true
    end

    # Add each action, if we should
    add :index, params                             if should_add[:index]
    add :new, params                               if should_add[:new]
    add :create, params                            if should_add[:create]
    add :edit, {:id => "some_id"}.merge(params)    if should_add[:edit]
    add :show, {:id => "some_id"}.merge(params)    if should_add[:show]
    add :update, {:id => "some_id"}.merge(params)  if should_add[:update]
    add :destroy, {:id => "some_id"}.merge(params) if should_add[:destroy]
  end

  def output
    @store.map do |format, requests|
      Output.generate_steps_for format, requests
    end.join("\n\n")
  end

  def method_missing method, *args
    add(method, *args)
  end

end
