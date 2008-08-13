($:.unshift File.expand_path(File.join( File.dirname(__FILE__), '..', 'lib' ))).uniq!
require 'stringray'

describe 'a String including StringRay' do
  before :all do
    String.send :include, StringRay
  end
  
  describe "#enumerate" do
    # Unsemantic tests; laziness
    it "should return an array of text elements" do
      string = "You like snapples, mulberries and tandem jockeys?"
      string.enumerate.should == ["You", " ", "like", " ", "snapples", ",",
        " ", "mulberries", " ", "and", " ", "tandem", " ", "jockeys", "?"]
    end
    
    it "should yield each text element if passed a block" do
      string = "My coffee glass is moldy; why has it not been erased?"
      expected_array = ["My", " ", "coffee", " ", "glass", " ", "is", " ",
        "moldy", ";", " ", "why", " ", "has", " ", "it", " ", "not", " ",
        "been", " ", "erased", "?"]
      
      string.enumerate do |element|
        element.should == expected_array.shift
      end
    end
    
    it "should return self if passed a block" do
      string = "It appears the clouds have shrunk. Maybe it is time " +
        "to build a sand castle after all?"
      string.enumerate{nil}.should == string
    end
  end
  
  describe 'iteration' do
    it 'should split a string into an array' do
      string = 'The time has come to talk of many things - of sailing ' +
        'ships and sealing wax, of cabbages and kings!'
      string.inject([]) {|a, i| a << i }.should == 
        ['The ','time ','has ','come ','to ','talk ','of ',
        'many ','things - ','of ','sailing ','ships ','and ','sealing ',
        'wax, ','of ','cabbages ','and ','kings!']
    end
    
    it 'should correctly treat commas and lists' do
      string = 'I have commas, periods, and other punctuation'
      string.inject([]) {|a, i| a << i }.should == 
        ['I ','have ','commas, ','periods, ','and ','other ','punctuation']
    end
    
    it 'should correctly treat periods and end-of-sentence demarcators' do
      string = 'Periods. Cool right? Yah!'
      string.inject([]) {|a, i| a << i }.should == 
        ['Periods. ','Cool ','right? ','Yah!']
    end
    
    it 'should correctly treat dahses' do
      string = 'I have - uh - dashes!'
      string.inject([]) {|a, i| a << i }.should == 
        ['I ','have - ','uh - ','dashes!']
    end
    
    it 'should correctly treat ellipses' do
      string = 'Where are we... going?'
      string.inject([]) {|a, i| a << i }.should == 
        ['Where ','are ','we... ','going?']
    end
    
    it 'should correctly treat a delimated word' do
      string = 'String and Array, sitting in a tree - K-I-S-S-I-N-G!'
      string.inject([]) {|a, i| a << i }.should == 
        ['String ','and ','Array, ','sitting ','in ','a ','tree - ','K-','I-','S-','S-','I-','N-','G!']
    end
    
    it 'should correctly treat inline line returns' do
      string = "This has\na line return!"
      string.inject([]) {|a, i| a << i }.should == 
        ["This ","has\n","a ","line ","return!"]
    end
    
    it 'should correctly treat prefacing line returns and whitespace' do
      string = "\n  Now it starts!\n\n"
      string.inject([]) {|a, i| a << i }.should == 
        ["\n  Now ","it ","starts!\n\n"]
    end
  end
  
  describe '#each_word specific behavior' do
    it 'should be able to attach delimeters to the beginning of the next word' do
      string = 'The time has come to talk of many things - of sailing ' +
        'ships and sealing wax, of cabbages and kings!'
      array = []
      string.each(:delemiters => :attach_after) {|i| array << i }
      array.should == ['The ','time ','has ','come ','to ','talk ','of ',
        'many ','things ','- of ','sailing ','ships ','and ','sealing ',
        'wax',', of ','cabbages ','and ','kings!']
    end
    
    it 'should be able to let delimeters stand alone' do
      string = 'The time has come to talk of many things - of sailing ' +
        'ships and sealing wax, of cabbages and kings!'
      array = []
      string.each(:delemiters => :standalone) {|i| array << i }
      array.should == ['The ','time ','has ','come ','to ','talk ','of ',
        'many ','things ','- ', 'of ','sailing ','ships ','and ','sealing ',
        'wax',', ','of ','cabbages ','and ','kings','!']
    end
    
    it 'should be able to attach whitespace to the beginning of the next word' do
      string = 'The time has come to talk of many things - of sailing ' +
        'ships and sealing wax, of cabbages and kings!'
      array = []
      string.each(:whitespace => :attach_after) {|i| array << i }
      array.should == ['The',' time',' has',' come',' to',' talk',' of',
        ' many',' things',' - of',' sailing',' ships',' and',' sealing',
        ' wax,',' of',' cabbages',' and',' kings!']
    end
    
    it 'should be able to let whitespace stand alone' do
      string = 'The time has come to talk of many things - of sailing ' +
        'ships and sealing wax, of cabbages and kings!'
      array = []
      string.each(:whitespace => :standalone) {|i| array << i }
      array.should == ['The',' ','time',' ','has',' ','come',' ','to',' ','talk',' ','of',
        ' ','many',' ','things',' -',' ','of',' ','sailing',' ','ships',' ','and',' ','sealing',
        ' ','wax,',' ','of',' ','cabbages',' ','and',' ','kings!']
    end
  end
  
  # TODO: Figure out a better way to say 'should be_include(Enumerable)'
  it 'should also include enumerable' do
    String.ancestors.should be_include(Enumerable)
  end
end