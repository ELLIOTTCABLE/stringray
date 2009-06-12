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
  
end

