module StringRay
  VERSION = 2
  
  ##
  # 
  attr_accessor :whitespace
  
  attr_accessor :delemiters
  
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
  def to_stray
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
  # @see #whitespace
  # @see #delemiters
  # Enumerates a string, similar to +#to_stray+, but returning an array of
  # plain +String+s instead of container objects.
  # 
  # @param [Hash] options A hash of options
  # @yield [word] Allows each word in the string to be operated on after it is
  #   processed
  # @yieldparam [String] word The last processed word
  # @return [Array[String]] An array of words
  # @since 1
  def enumerate options = {}, &block
    {:whitespace => :attach_before, :delemiters => :attach_before}.merge! options
    
    # First, we create a two-dimensional array of words with any whitespace or
    # delemiters that should attach to them.
    mapped = []
    attach_before_next = []
    
    self.to_stray do |element|
      case element
      when Delimiter
        case options[:delemiters]
        when :standalone
          mapped << [element]
        when :attach_after
          attach_before_next << element
        else
          if attach_before_next.empty?
            if mapped.last
              mapped.last << element
            else
              attach_before_next << element
            end
          else
            attach_before_next << element
          end
        end
        
      when Whitespace
        case options[:whitespace]
        when :standalone
          mapped << [element]
        when :attach_after
          attach_before_next << element
        else
          if attach_before_next.empty?
            if mapped.last
              mapped.last << element
            else
              attach_before_next << element
            end
          else
            attach_before_next << element
          end
        end
        
      when Word
        if not attach_before_next.empty?
          mapped << [attach_before_next, element].flatten
          attach_before_next = []
        else
          mapped << [element]
        end
        
      end
    end
    
    if not attach_before_next.empty?
      mapped << [Word.new] unless mapped.last
      (mapped.last << attach_before_next).flatten!
    end
    
    # Next, we yield each group of (word plus delimiters and whitespace) as a
    # normal string to the block, and return an array of these
    mapped.map do |arr|
      string = arr.map{|w|w.to_s}.join
      yield string if block_given?
      string
    end
  end
  
  # @deprecated
  alias_method :each_word, :enumerate
  
  def Word word; Word.new word; end
  class Word < String
    def inspect
      "(#{self})"
    end
  end
  
  def Whitespace whitespace; Whitespace.new whitespace; end
  class Whitespace < String
    Characters = [" ", "\t", "\n"]
    def inspect
      "#{self}"
    end
  end
  
  def Delimiter delimiter; Delimiter.new delimiter; end
  class Delimiter < String
    Characters = ['-', ',', '.', '?', '!', ':', ';', '/', '\\', '|']
    
    def inspect
      "<#{self}>"
    end
  end
  
  ##
  # This is mixed into any class including +StringRay+. It exposes
  # +::make_enumerable!+ to said class.
  module Extendables
    # This overrides +String#each+ with +StringRay#enumerate+, thus allowing
    # us to include +Enumerable+. Be careful, this breaks lots of existing
    # code which depends on the old methodology of +String#each+! The
    # overridden +String#each+ functionality will be exposed as
    # +String#each_at+.
    def make_enumerable!
      self.class_eval do
        alias_method :each_at, :each
        alias_method :each, :enumerate
        
        include Enumerable
      end
    end
  end
  
  def self.included klass
    klass.send :extend, Extendables
  end
end