
require 'rspec/core/rake_task'

require 'space_craft'

RSpec::Core::RakeTask.new(:spec)

task 'sandbox' do
  puts 123
end


task :default => :spec


begin
  require 'bones'
rescue LoadError
  abort '### Please install the "bones" gem ###'
end

#task :default => 'test:run'
task 'gem:release' => 'test:run'

Bones {
  name     'space_craft'
  authors  'FIXME (who is writing this software)'
  email    'FIXME (your e-mail)'
  url      'FIXME (project homepage)'
}



