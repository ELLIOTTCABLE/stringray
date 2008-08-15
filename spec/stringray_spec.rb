($:.unshift File.expand_path(File.join( File.dirname(__FILE__), '..', 'lib' ))).uniq!
require 'stringray'

# Some shortcusts, because the author is a lazy typist...
def Word word;              StringRay::Word.new word;             end
def Whitespace whitespace;  StringRay::Whitespace.new whitespace; end
def Delimiter delimiter;    StringRay::Delimiter.new delimiter;   end
Space   = Whitespace ' '
Period  = Delimiter '.'

describe 'a String including StringRay' do
  before :all do
    class String
      include StringRay
    end
  end
  
  describe "#to_stray" do
    it "should return a multi-dimensional array of container elements" do
      string = 'This is a string.'
      string.to_stray.should ==
        [Word('This'), Space, Word('is'), Space, Word('a'), Space, Word('string'), Period]
    end
    
    it "should yield each text element if passed a block" do
      string = 'This is a string.'
      
      yielded = []
      string.to_stray do |element|
        yielded << element
      end
      
      yielded.should ==
        [Word('This'), Space, Word('is'), Space, Word('a'), Space, Word('string'), Period]
    end
  end
  
  describe '#enumerate' do
    it 'should split a string into an array' do
      string = 'This is a string'
      string.enumerate.should == 
        ['This ','is ','a ','string']
    end
    
    it 'should correctly treat commas and lists' do
      string = 'Commas, commas, commas'
      string.enumerate.should == 
        ['Commas, ','commas, ','commas']
    end
    
    it 'should correctly treat periods and end-of-sentence demarcators' do
      string = 'Punctuation. Cool right? Yah!'
      string.enumerate.should == 
        ['Punctuation. ','Cool ','right? ','Yah!']
    end
    
    it 'should correctly treat dahses' do
      string = 'I have - uh - dashes'
      string.enumerate.should == 
        ['I ','have - ','uh - ','dashes']
    end
    
    it 'should correctly treat ellipses' do
      string = 'Where... are we... going'
      string.enumerate.should == 
        ['Where... ','are ','we... ','going']
    end
    
    it 'should correctly treat a delimated word' do
      pending
      string = 'W-o-r-d-s a-r-e c-o-o-l'
      string.enumerate.should == 
        ['W-o-r-d-s ','a-r-e ','c-o-o-l']
    end
    
    it 'should correctly treat inline line returns' do
      string = "Line\nreturns\nyay"
      string.enumerate.should == 
        ["Line\n","returns\n","yay"]
    end
    
    it 'should correctly treat prefacing line returns and whitespace' do
      string = "\n\t # Code\n\n"
      string.enumerate.should == 
        ["\n\t # ","Code\n\n"]
    end
    
    describe '(method options hash)' do
      it 'should be able to attach delimeters to the beginning of the next word' do
        string = 'The time has come to talk of many things - of sailing ' +
          'ships and sealing wax, of cabbages and kings!'
        string.enumerate(:delemiters => :attach_after).should == 
          ['The ','time ','has ','come ','to ','talk ','of ',
          'many ','things ','- of ','sailing ','ships ','and ','sealing ',
          'wax',', of ','cabbages ','and ','kings!']
      end
    
      it 'should be able to let delimeters stand alone' do
        string = 'The time has come to talk of many things - of sailing ' +
          'ships and sealing wax, of cabbages and kings!'
        string.enumerate(:delemiters => :standalone).should ==
          ['The ','time ','has ','come ','to ','talk ','of ',
          'many ','things ','- ', 'of ','sailing ','ships ','and ','sealing ',
          'wax',', ','of ','cabbages ','and ','kings','!']
      end
    
      it 'should be able to attach whitespace to the beginning of the next word' do
        string = 'The time has come to talk of many things - of sailing ' +
          'ships and sealing wax, of cabbages and kings!'
        string.enumerate(:whitespace => :attach_after).should ==
          ['The',' time',' has',' come',' to',' talk',' of',
          ' many',' things',' - of',' sailing',' ships',' and',' sealing',
          ' wax,',' of',' cabbages',' and',' kings!']
      end
    
      it 'should be able to let whitespace stand alone' do
        string = 'The time has come to talk of many things - of sailing ' +
          'ships and sealing wax, of cabbages and kings!'
        string.enumerate(:whitespace => :standalone).should ==
          ['The',' ','time',' ','has',' ','come',' ','to',' ','talk',' ','of',
          ' ','many',' ','things',' -',' ','of',' ','sailing',' ','ships',' ','and',' ','sealing',
          ' ','wax,',' ','of',' ','cabbages',' ','and',' ','kings!']
      end
    end
    
    describe '(class setter methods)' do
      before :each do
        StringRay::whitespace = nil
        StringRay::delemiters = nil
      end
      
      it 'should allow delemiter handling to be set through a class method' do
        StringRay::whitespace = :attach_after
        string = 'The time has come to talk of many things - of sailing ' +
          'ships and sealing wax, of cabbages and kings!'
        string.enumerate.should ==
          ['The',' time',' has',' come',' to',' talk',' of',
          ' many',' things',' - of',' sailing',' ships',' and',' sealing',
          ' wax,',' of',' cabbages',' and',' kings!']
        
        StringRay::whitespace = :standalone
        string = 'The time has come to talk of many things - of sailing ' +
          'ships and sealing wax, of cabbages and kings!'
        string.enumerate.should ==
          ['The',' ','time',' ','has',' ','come',' ','to',' ','talk',' ','of',
          ' ','many',' ','things',' -',' ','of',' ','sailing',' ','ships',' ','and',' ','sealing',
          ' ','wax,',' ','of',' ','cabbages',' ','and',' ','kings!']
      end
      
      it 'should allow whitespace handling to be set through a class method' do
        StringRay::whitespace = :attach_after
        string = 'The time has come to talk of many things - of sailing ' +
          'ships and sealing wax, of cabbages and kings!'
        string.enumerate.should ==
          ['The',' time',' has',' come',' to',' talk',' of',
          ' many',' things',' - of',' sailing',' ships',' and',' sealing',
          ' wax,',' of',' cabbages',' and',' kings!']
        
        StringRay::whitespace = :standalone
        string = 'The time has come to talk of many things - of sailing ' +
          'ships and sealing wax, of cabbages and kings!'
        string.enumerate.should ==
          ['The',' ','time',' ','has',' ','come',' ','to',' ','talk',' ','of',
          ' ','many',' ','things',' -',' ','of',' ','sailing',' ','ships',' ','and',' ','sealing',
          ' ','wax,',' ','of',' ','cabbages',' ','and',' ','kings!']
      end
    end
  end
  
  # TODO: Figure out a better way to say 'should be_include(Enumerable)'
  # it 'should also include enumerable' do
  #   EString.ancestors.should be_include(Enumerable)
  # end
end