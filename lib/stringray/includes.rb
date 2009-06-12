class StringRay < Array
  
  # This is mixed into any class including +StringRay+. It exposes
  # +#to_stray+ and +#enumerate+ to said class's instances.
  module Includes
    
    @@whitespace = nil
    @@delemiters = nil
    
    ##
    # @see #enumerate
    # @see StringRay.whitespace=
    # Controls how +#enumerate+ deals with whitespace by default.
    # 
    # @param [Symbol] whitespace How to handle whitespace - :attach_before,
    #   :standalone, or :attach_after
    def self.whitespace= whitespace
      @@whitespace = whitespace
    end
    
    def self.whitespace
      @@whitespace || StringRay::whitespace
    end
    
    ##
    # @see #enumerate
    # @see StringRay.delemiters=
    # Controls how +#enumerate+ deals with delemiters by default.
    # 
    # @param [Symbol] delemiters How to handle delemiters - :attach_before,
    #   :standalone, or :attach_after
    def self.delemiters= delemiters
      @@delemiters = delemiters
    end
    
    def self.delemiters
      @@delemiters || StringRay::delemiters
    end

    ##
    # Splits a string into an array of +StringRay+ container objects (+Word+,
    # +Whitespace+, and +Delimiter+).
    # 
    # @yield [element] Allows each 'element' of the string to be operated on
    #   after it is processed
    # @yieldparam [Word, Whitespace, Delimiter] element The last processed
    #   string 'element'
    # @return [StringRay[Word, Whitespace, Delimiter]] An array of +StringRay+
    #   container objects
    # @since 2
    def to_stray
      ray = StringRay.new
      new_element = lambda do |element|
        yield ray.last if block_given? unless ray.empty?
        ray << element
      end
      
      self.scan(/./um) do |char|
        if Delimiter::Characters.include? char
          new_element[Delimiter.new(char)]
          
        elsif Whitespace::Characters.include? char
          if ray.last.is_a? Whitespace
            ray.last << char
          else
            new_element[Whitespace.new(char)]
          end
          
        else
          if ray.last.is_a? Word
            ray.last << char
          else
            new_element[Word.new(char)]
          end
          
        end
      end
      
      if block_given?
        yield ray.last
        self
      else
        ray
      end
    end
    
    def enumerate options = {}, &block
      self.to_stray.enumerate options, &block
    end
    
    # @deprecated
    alias_method :each_word, :enumerate
    
    unless RUBY_VERSION <= "1.9"
      alias_method :each, :enumerate
      include Enumerable
    end
    
  end
end

