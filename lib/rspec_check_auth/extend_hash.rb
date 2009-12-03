unless Hash.respond_to?(:except)
  # Returns self minus any keys specified
  module HashExcept
    def except(*blacklist)
      self.reject {|key, value| blacklist.include?(key) }
    end
  end
  Hash.send(:include, HashExcept)
end
