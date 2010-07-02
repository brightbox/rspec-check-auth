require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CheckAuth::Request do

  it "should create a valid instance" do
    CheckAuth::Request.new(:index, :html, {}).should_not be_nil
  end

  it "should have default params when not overridden" do
    r = CheckAuth::Request.new(:update, :html, {})
    r.params.should == {:id => "some_id"}
  end

  it "should have a default id for show, edit, update, destroy actions" do
    [:show, :edit, :update, :destroy].each do |action|
      r = CheckAuth::Request.new(action, :html, {})
      r.params.should == {:id => "some_id"}
    end
  end

  it "should have no default params for index, new, create" do
    [:index, :new, :create].each do |action|
      r = CheckAuth::Request.new(action, :html, {})
      r.params.should == {}
    end
  end

  it "should override default params with custom ones" do
    r = CheckAuth::Request.new(:update, :html, {:id => "blah blah"})
    r.params.should == {:id => "blah blah"}
  end

  it "should not include :format in the params when format is html" do
    r = CheckAuth::Request.new(nil, :html, {})
    r.params.should == {}
  end

  it "should include :format in the params when format is not html" do
    r = CheckAuth::Request.new(nil, :xml, {})
    r.params.should == {:format => "xml"}
  end

end
