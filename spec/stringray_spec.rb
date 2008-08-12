require 'stringray'

describe 'a String including StringRay' do
  before :all do
    String.send :include, StringRay
  end
  
  describe '#enumerate' do
    it 'should split a string into an array' do
      string = 'The time has come to talk of many things - of sailing ' +
        'ships and sealing wax, of cabbages and kings!'
      array = []
      string.each {|i| array << i }
      array.should == ['The ','time ','has ','come ','to ','talk ','of ',
        'many ','things - ','of ','sailing ','ships ','and ','sealing ',
        'wax, ','of ','cabbages ','and ','kings!']
    end
    
    it 'should correctly treat commas and lists' do
      string = 'I have commas, periods, and other punctuation'
      array = []
      string.each {|i| array << i }
      array.should == ['I ','have ','commas, ','periods, ','and ','other ','punctuation']
    end
    
    it 'should correctly treat periods and end-of-sentance demarcators' do
      string = 'Periods. Cool right? Yah!'
      array = []
      string.each {|i| array << i }
      array.should == ['Periods. ','Cool ','right? ','Yah!']
    end
    
    it 'should correctly treat dahses' do
      string = 'I have - uh - dashes!'
      array = []
      string.each {|i| array << i }
      array.should == ['I ','have - ','uh - ','dashes!']
    end
    
    it 'should correctly treat ellipses' do
      string = 'Where are we... going?'
      array = []
      string.each {|i| array << i }
      array.should == ['Where ','are ','we... ','going?']
    end
  end
  
  describe '#each_word' do
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
    
    it 'should be able to not split a delimated word' do
      pending "Figure out a way to allow delemiters to _not_ split words " +
        "- i.e. 'K-I-S-S-I-N-G' should be passed as a single word."
      
      string = "String and Array, sitting in a tree - K-I-S-S-I-N-G!"
      array = string.map
      array.should == ['String ','and ','Array, ','sitting ','in ','a ','tree - ','K-','I-','S-','S-','I-','N-','G!']
    end
  end
  
  # TODO: Figure out a better way to say 'should be_include(Enumerable)'
  it 'should also include enumerable' do
    String.ancestors.should be_include(Enumerable)
  end
end