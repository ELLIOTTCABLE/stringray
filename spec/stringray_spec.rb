($:.unshift File.expand_path(File.join( File.dirname(__FILE__), '..', 'lib' ))).uniq!
require 'stringray'

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
  end
  
  it 'should provide #enumerate' do
    s = @S.new
    s.should respond_to(:enumerate)
  end
end
