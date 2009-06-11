module Kernel
  def self.warn message
    super "#{caller[-1]}: warning: #{message}"
  end
end

