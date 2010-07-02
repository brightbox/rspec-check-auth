require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "RspecCheckAuth" do

  it "should require a checking block" do
    lambda { CheckAuth.checking_block }.should raise_error("CheckAuth#checking_block needs defining")
  end

  it "should call the checking block when one is set" do
    CheckAuth.checking_block do
      raise "I'm in the block!"
    end

    lambda { CheckAuth.checking_block }.should raise_error("I'm in the block!")
  end

  it "should add an action with default formats" do
    expect_request_for(:route, :html)
    expect_request_for(:route, :xml)

    expect_output_for(:html, [:"route_html"])
    expect_output_for(:xml, [:"route_xml"])

    CheckAuth.for do |c|
      c.add :route
    end
  end

  it "should add an action with custom params" do
    expect_request_for :route, :html, :some => :fields
    expect_request_for :route, :xml, :some => :fields
    
    expect_output_for :html, [:route_html]
    expect_output_for :xml, [:route_xml]

    CheckAuth.for do |c|
      c.add :route, :some => :fields
    end
  end
  
  it "should add an action with custom formats" do
    expect_request_for :route, :html
    expect_request_for :route, :json
    expect_request_for :route, :fart
    
    expect_output_for :html, [:route_html]
    expect_output_for :json, [:route_json]
    expect_output_for :fart, [:route_fart]
    
    CheckAuth.for do |c|
      c.add :route, :format => [:html, :json, :fart]
    end
  end

  it "should add an action with custom params and custom formats" do
    expect_request_for :route, :html, :some => :fields
    expect_request_for :route, :json, :some => :fields
    expect_request_for :route, :fart, :some => :fields
    
    expect_output_for :html, [:route_html]
    expect_output_for :json, [:route_json]
    expect_output_for :fart, [:route_fart]
    
    CheckAuth.for do |c|
      c.add :route, :format => [:html, :json, :fart], :some => :fields
    end
  end

  it "should add standard resource routes in one line" do
    expect_requests_for_resource_actions

    expect_output_for(:html, [:index_html, :new_html, :create_html, :edit_html, :show_html, :update_html, :destroy_html])
    expect_output_for(:xml, [:index_xml, :new_xml, :create_xml, :edit_xml, :show_xml, :update_xml, :destroy_xml])

    CheckAuth.for do |c|
      c.resource_actions
    end
  end

  it "should ignore resources it's been told to" do
    expect_request_for :index, :html
    expect_request_for :index, :xml

    expect_output_for(:html, [:index_html])
    expect_output_for(:xml, [:index_xml])

    CheckAuth.for do |c|
      c.resource_actions :except => [:new, :show, :edit, :update, :create, :destroy]
    end
  end

  it "should only expect resources it's been told to" do
    expect_request_for :index, :html
    expect_request_for :index, :xml

    expect_output_for(:html, [:index_html])
    expect_output_for(:xml, [:index_xml])

    CheckAuth.for do |c|
      c.resource_actions :only => :index
    end
  end

  it "should add standard resource routes with extra params" do
    expect_requests_for_resource_actions :some => :fields

    expect_output_for(:html, [:index_html, :new_html, :create_html, :edit_html, :show_html, :update_html, :destroy_html])
    expect_output_for(:xml, [:index_xml, :new_xml, :create_xml, :edit_xml, :show_xml, :update_xml, :destroy_xml])

    CheckAuth.for do |c|
      c.resource_actions :some => :fields
    end
  end

  it "should add standard resource routes with extra formats" do
    expect_requests_for_resource_actions({}, [:html, :json, :fart])

    expect_output_for(:html, [:index_html, :new_html, :create_html, :edit_html, :show_html, :update_html, :destroy_html])
    expect_output_for(:json, [:index_json, :new_json, :create_json, :edit_json, :show_json, :update_json, :destroy_json])
    expect_output_for(:fart, [:index_fart, :new_fart, :create_fart, :edit_fart, :show_fart, :update_fart, :destroy_fart])

    CheckAuth.for do |c|
      c.resource_actions :format => [:html, :json, :fart]
    end
  end

  it "should add standard resource routes with extra params and extra formats" do
    expect_requests_for_resource_actions({:some => :fields}, [:html, :json, :fart])

    expect_output_for(:html, [:index_html, :new_html, :create_html, :edit_html, :show_html, :update_html, :destroy_html])
    expect_output_for(:json, [:index_json, :new_json, :create_json, :edit_json, :show_json, :update_json, :destroy_json])
    expect_output_for(:fart, [:index_fart, :new_fart, :create_fart, :edit_fart, :show_fart, :update_fart, :destroy_fart])

    CheckAuth.for do |c|
      c.resource_actions :format => [:html, :json, :fart], :some => :fields
    end
  end



  private

  def expect_requests_for_resource_actions options={}, formats=[:html, :xml]
    formats.each do |f|
      expect_request_for(:index, f, options)
      expect_request_for(:new, f, options)
      expect_request_for(:create, f, options)
      expect_request_for(:edit, f, options.merge(:id => "some_id"))
      expect_request_for(:show, f, options.merge(:id => "some_id"))
      expect_request_for(:update, f, options.merge(:id => "some_id"))
      expect_request_for(:destroy, f, options.merge(:id => "some_id"))
    end
  end

  def expect_request_for action, format, options={}
    CheckAuth::Request.should_receive(:new).with(action, format, options).and_return(:"#{action}_#{format}")
  end

  def expect_output_for format, actions=[]
    CheckAuth::Output.should_receive(:generate_steps_for).with(format, actions)
  end
end
