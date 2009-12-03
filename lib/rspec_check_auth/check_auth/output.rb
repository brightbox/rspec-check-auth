class CheckAuth
  # Handles generating the code to eval from all the request objects
  class Output

    def self.generate_steps_for format, objects
      # Wrap each format in a new describe block
      o = [%Q{describe "as #{format.to_s.upcase}" do}]
        # Run through each step
        objects.each do |request|
          o << <<-EOF
  it "should return 401 for #{request.method.to_s.upcase} #{request.action}" do
    #{request.method}(#{request.action.inspect}#{", " + request.params.inspect})

    #{CheckAuth.checking_block(format)}
  end
          EOF
        end
      o << "end"
      o.join("\n")
    end
  end
end