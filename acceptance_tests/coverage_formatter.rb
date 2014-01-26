require 'rspec'
require 'rspec/core/formatters/documentation_formatter'

class CoverageFormatter < RSpec::Core::Formatters::DocumentationFormatter

  
  def example_group_finished(example_group)
    super
    @feature = example_group.description
    @scenarios = example_group.examples.map do |example|
      example.description
    end
    
    @lines = File.readlines("./stories/#{@feature.downcase}.txt").map {|l| l.chomp}
    
    puts
    
    coverage = @lines - @scenarios
    coverage_percentage = 100.0 - (coverage.size*100.0/@lines.size.to_f)
    puts "Overall test case coverage is #{"%.2f%" % coverage_percentage}"
    
    passed_scenarios = example_group.examples.map do |example|
      example.description if example.metadata[:execution_result][:status] == "passed"
    end    

    passed_coverage = @lines - passed_scenarios
    passed_coverage_percentage = 100.0 - (passed_coverage.size*100.0/@lines.size.to_f)
    puts "Passed test case coverage is #{"%.2f%" % passed_coverage_percentage}"   
    puts "---" 
  end

  def current_indentation
    "- " unless @group_level == 0
  end

end