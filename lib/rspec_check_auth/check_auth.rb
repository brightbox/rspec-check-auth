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
  # Accepts :except => [:action, :names] for actions to be skipped in testing
  # 
  def resource_actions params={}
    skip = params.delete(:except).arrayize || {}
    params[:format] = params.has_key?(:format) ? params[:format].arrayize : [:html,:xml]
    # Add each action, unless they should be skipped
    add :index, params  unless skip.include?(:index)
    add :new, params    unless skip.include?(:new)
    add :create, params unless skip.include?(:create)
    add :edit, {:id => "some_id"}.merge(params)   unless skip.include?(:edit)
    add :show, {:id => "some_id"}.merge(params)   unless skip.include?(:show)
    add :update, {:id => "some_id"}.merge(params) unless skip.include?(:update)
    add :destroy, {:id => "some_id"}.merge(params) unless skip.include?(:destroy)
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
