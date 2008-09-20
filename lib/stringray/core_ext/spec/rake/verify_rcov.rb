class RCov::VerifyTask
  
  # For now, it appears that StringRay's habit of fucking with #each, also
  # screws with RCov generation. RSpec's verification task's fragile code
  # doesn't like that... so let's fix it.
  def define
    desc "Verify that rcov coverage is at least #{threshold}%"
    task @name do
      total_coverage = nil

      File.open(index_html).each_line do |line|
        if line =~ /<tt\s+class='coverage_total'>\s*(\d+\.\d+)%\s*<\/tt>/
          total_coverage = $1.to_s.to_f
          break
        end
      end
      puts "Coverage: #{total_coverage}% (threshold: #{threshold}%)" if verbose
      raise "Coverage must be at least #{threshold}% but was #{total_coverage}%" if total_coverage < threshold
      raise "Coverage has increased above the threshold of #{threshold}% to #{total_coverage}%. You should update your threshold value." if (total_coverage > threshold) and require_exact_threshold
    end
  end
  
end