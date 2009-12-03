unless Object.respond_to?(:arrayize)
  module Arrayize
    # Returns an object containing self,
    # unless self is an Array already.
    def arrayize
      return [self] unless self.is_a?(Array)
      self
    end
  end
  Object.send(:include, Arrayize)
end
