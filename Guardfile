# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :bundler do
  watch('Gemfile')
end

guard :rspec, :cli => "--color --format nested" do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^(.+)\.rb$}) { "spec" }
  watch(%r{^app/(.+)\.rb$}) { "spec" }
  watch('spec/spec_helper.rb')  { "spec" }
end

