require "rspec_check_auth/extend_hash"
require "rspec_check_auth/extend_object"
require "rspec_check_auth/check_auth"
require "rspec_check_auth/check_auth/request"
require "rspec_check_auth/check_auth/output"

def check_auth_for &block
  return unless block
  eval(CheckAuth.for &block)
end
