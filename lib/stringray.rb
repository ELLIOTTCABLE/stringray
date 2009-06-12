require 'stringray/core_ext'
require 'stringray/includes'

class StringRay < Array
  Version = 3
  
  @@whitespace = nil
  @@delemiters = nil
  
  ##
  # @see StringRay::Includes#enumerate
  # @see StringRay::Includes.whitespace=
  # Controls how +StringRay::Includes#enumerate+ deals with whitespace by default.
  # 
  # @param [Symbol] whitespace How to handle whitespace - :attach_before,
  #   :standalone, or :attach_after
  def self.whitespace= whitespace
    @@whitespace = whitespace
  end
  
  def self.whitespace
    @@whitespace ||= :attach_before
  end

  ##
  # @see StringRay::Includes#enumerate
  # @see StringRay::Includes.delemiters=
  # Controls how +StringRay::Includes#enumerate+ deals with delemiters by default.
  # 
  # @param [Symbol] delemiters How to handle delemiters - :attach_before,
  #   :standalone, or :attach_after
  def self.delemiters= delemiters
    @@delemiters = delemiters
  end
  
  def self.delemiters
    @@delemiters ||= :attach_before
  end
  
  # @see StringRay::Word.new
  def self.Word word; Word.new word; end
  
  ##
  # @see StringRay::Includes#to_stray
  # @see #whitespace
  # @see #delemiters
  # Enumerates a string, returning an array plain +String+s.
  # 
  # @param [Hash] options A hash of options
  # @yield [word] Allows each word in the string to be operated on after it is
  #   processed
  # @yieldparam [String] word The last processed word
  # @return [Array[String]] An array of words
  # @since 1
  def enumerate options = {}, &block
    # TODO: Can we clean this up, into a simple #inject call? I bet so.
    # TODO: This really should return an Enumerator object. Seriously.
    mapped = []
    attach_before_next = []
    
    self.each do |element|
      case element
      when Delimiter
        case options[:delemiters] || StringRay::delemiters
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
        case options[:whitespace] || StringRay::whitespace
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
    
    mapped.map do |arr|
      string = arr.map{|w|w.to_s}.join
      yield string if block_given?
      string
    end
  end
  
  ##
  # A wrapper class for strings that are 'words' in and of themselves,
  # composed of 'word characters'.
  class Word < String
    def inspect
      "(#{self})"
    end
  end
  
  # @see StringRay::Whitespace.new
  def self.Whitespace whitespace; Whitespace.new whitespace; end
  
  ##
  # A wrapper class for strings that are 'whitespace' composed of 'whitespace
  # characters'.
  class Whitespace < String
    Characters = [" ", "\t", "\n"]
    
    def inspect
      "#{self}"
    end
  end
  
  # @see StringRay::Delimiter.new
  def self.Delimiter delimiter; Delimiter.new delimiter; end
  
  ##
  # A wrapper class for strings that are 'delimiters' composed of 'delimiter
  # characters'.
  class Delimiter < String
    Characters = ['-', ',', '.', '?', '!', ':', ';', '/', '\\', '|']
    
    def inspect
      "<#{self}>"
    end
  end
  
  def inspect
    "\"#{self.map(&:inspect).join ''}\""
  end
  
end

