# RSpec Check-Auth

Check-Auth makes it easier to test your controller actions require authentication.

## Installation

	gem install rspec-check-auth

To use check-auth you need to give it a block. This block returns the right bit of code (as a string to be eval'd) for that format. For instance, to check a HTML request it needs to be redirected, but for an XML request it should just be a 403 response.

Here's an example block that expects HTML to be redirected to login_url and XML/JSON requests to be given a 403 response:

	CheckAuth.checking_block do |format|
	  case format
	  when :html
	    a = <<-EOF
	      response.should be_redirect
	      response.location.should == login_url
	    EOF
	  when :xml
	    "response.should be_unauthorised"
	  when :json
	    "response.should be_unauthorised"
	  else
	    %Q{raise "#{format} not defined in checking_block"}
	  end
	end

## Usage

CheckAuth knows about different HTTP methods, and can figure out the usual crowd (POST create, DELETE destroy, etc.) You can override the method by passing a `:method` argument.

	check_auth_for do |c|
		c.index
		c.index :method => :post
	end

You can test your resourceful controller in one fell swoop too.

	check_auth_for {|c| c.resource_actions }

Feel free to add any additional params for the resources, or any normal action.

	check_auth_for do |c|
		c.resource_actions :parent_id => "some_id"
		c.parent_info :parent_id => "some_id"
	end

By default it tests via HTMl and XML, but adding more or less formats is no issue. Just pass the `:format` arg.

	check_auth_for do |c|
		c.resource_actions :format => :html
		c.parent_info :format => [:html, :json]
	end

Only want some of the usual crowd? No problem, just pass the `:except` param and `resource_actions` will shun those specified.

	check_auth_for {|c| c.resource_actions :except => [:new, :create, :edit, :update] }

And finally here's a proper example from a Brightbox controller spec.

	check_auth_for do |c|
		c.resource_actions
		c.index :format => :json # above line does html/xml
		c.find_available_items :parent_id => 0, :size => 0, :format => :xml
		c.mailer :id => "some_id"
		c.mailer :method => :post, :id => "some_id"
	end

![](http://caius.name/images/qs/ThingyControllerSpec.png)

## Licence

See LICENCE