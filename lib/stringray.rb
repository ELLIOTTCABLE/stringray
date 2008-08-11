module StringRay
  # Splits a string into words. Not using the obvious names (+#split+, +#words+)
  # because I want compatibility for inclusion into +String+.
  def enumerate
    ray = []
    
    self.each_byte do |byte|
      char = byte.chr
      
      if Delimiter::Characters.include? char
        ray << Delimiter.new(char)
        
      elsif Whitespace::Characters.include? char
        if ray.last.is_a? Whitespace
          ray.last << char
        else
          ray << Whitespace.new(char)
        end
        
      else
        if ray.last.is_a? Word
          ray.last << char
        else
          ray << Word.new(char)
        end
        
      end
    end
    
    ray
  end
  
  # More sensible than +String#each+, this uses +#enumerate+ to enumerate on
  # words. Accepts options as a hash, determining whether :whitespace and
  # :delemiters will :attach_before, :standalone, or :attach_after. Default is
  # for both to :attach_before.
  def each_word opts = {}, &block
    {:whitespace => :attach_before, :delemiters => :attach_before}.merge! opts
    
    # First, we create a two-dimensional array of words with any whitespace or
    # delemiters that should attach to them.
    words = self.enumerate
    mapped = []
    attach_before_next = []
    
    words.each do |item|
      case item
      when Delimiter
        case opts[:delemiters]
        when :standalone
          mapped << [item]
        when :attach_after
          attach_before_next << item
        else
          if attach_before_next.empty?
            mapped.last << item
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
            mapped.last << item
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
    (mapped.last << attach_before_next).flatten! if not attach_before_next.empty?
    
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
    Characters = ['-', ',', '.', '?', '!']
    
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