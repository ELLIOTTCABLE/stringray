($:.unshift File.expand_path(File.join( File.dirname(__FILE__), '..', 'lib' ))).uniq!
require 'stringray'

Space   = StringRay::Whitespace ' '
Period  = StringRay::Delimiter '.'

describe 'a String-ish including StringRay::Includes' do
  before :all do
    @S = Class.new String
    @S.send :include, StringRay::Includes
  end

  it 'should provide #to_stray' do
    s = @S.new
    s.should respond_to(:to_stray)
  end
  describe '#to_stray' do
    it 'should return a StringRay container object' do
      s = @S.new
      s.to_stray.should be_an_instance_of(StringRay)
    end
    
    it 'should be Enumerable' do
      s = @S.new
      class<<s.to_stray; self; end.ancestors.should include(Enumerable)
    end

    it 'should translate words' do
      s = @S.new "foobar"
      s.to_stray.should == StringRay.new([StringRay::Word("foobar")])
    end

    it 'should translate delemiters' do
      s = @S.new "-"
      s.to_stray.should == StringRay.new([StringRay::Delimiter("-")])
    end

    it 'should translate whitespace' do
      s = @S.new " \n "
      s.to_stray.should == StringRay.new([StringRay::Whitespace(" \n ")])
    end

    it 'should translate combined sentances' do
      s = @S.new "I am a wookie."
      s.to_stray.should == StringRay.new([StringRay::Word("I"), Space, StringRay::Word("am"), Space, StringRay::Word("a"), Space, StringRay::Word("wookie"), Period])
    end
  end
  
  it 'should provide #enumerate' do
    s = @S.new
    s.should respond_to(:enumerate)
  end
end
