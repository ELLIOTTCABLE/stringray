module StringRay
  VERSION = 2
  
  ##
  # Splits a string into an array of +StringRay+ container objects (+Word+,
  # +Whitespace+, and +Delimiter+).
  # 
  # @yield [element] Allows each 'element' of the string to be operated on
  #   after it is processed
  # @yieldparam [Word, Whitespace, Delimiter] element The last processed
  #   string 'element'
  # @return [Array[Word, Whitespace, Delimiter]] An array of +StringRay+
  #   container objects
  # @since 2
  def enumerate
    ray = []
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
  
  ##
  # @see #to_stray
  # Enumerates a string, similar to +#to_stray+, but returning an array of
  # plain +String+s instead of container objects.
  # 
  # @param [Hash] options A hash of options
  # @yield [word] Allows each word in the string to be operated on after it is
  #   processed
  # @yieldparam [String] word The last processed word
  # @return [Array[String]] An array of words
  # @since 1
  def each_word opts = {}, &block
    {:whitespace => :attach_before, :delemiters => :attach_before}.merge! opts
    
    # First, we create a two-dimensional array of words with any whitespace or
    # delemiters that should attach to them.
    mapped = []
    attach_before_next = []
    
    self.enumerate do |item|
      case item
      when Delimiter
        case opts[:delemiters]
        when :standalone
          mapped << [item]
        when :attach_after
          attach_before_next << item
        else
          if attach_before_next.empty?
            if mapped.last
              mapped.last << item
            else
              attach_before_next << item
            end
          else
            attach_before_next << item
          end
        end
        
      when Whitespace
        case opts[:whitespace]
        when :standalone
          mapped << [item]
        when :attach_after
          attach_before_next << item
        else
          if attach_before_next.empty?
            if mapped.last
              mapped.last << item
            else
              attach_before_next << item
            end
          else
            attach_before_next << item
          end
        end
        
      when Word
        if not attach_before_next.empty?
          mapped << [attach_before_next, item].flatten
          attach_before_next = []
        else
          mapped << [item]
        end
        
      end
    end
    
    if not attach_before_next.empty?
      mapped << [Word.new] unless mapped.last
      (mapped.last << attach_before_next).flatten!
    end
    
    # Next, we yield each group of (word plus delimiters and whitespace) as a
    # normal string to the block
    mapped.each do |arr|
      yield arr.map{|w|w.to_s}.join
    end
  end
  
  class Word < String
    def inspect
      "(#{self})"
    end
  end
  
  class Whitespace < String
    Characters = [" ", "\t", "\n"]
    def inspect
      "#{self}"
    end
  end
  
  class Delimiter < String
    Characters = ['-', ',', '.', '?', '!', ':', ';', '/', '\\', '|']
    
    def inspect
      "<#{self}>"
    end
  end
  
  # This overrides +String#each+ with +StringRay#each_word+, thus allowing us
  # to include +Enumerable+.
  def self.included klass
    klass.class_eval do
      alias_method :each_at, :each
      alias_method :each, :each_word
      
      include Enumerable
    end
  end
end