notification :off

guard 'spork' do
  watch('Gemfile')
  watch('spec/spec_helper.rb')     { :rspec }
  watch(%r{^spec/support/.+\.rb$}) { :rspec }
end

guard 'yard', stdout: '/dev/null', stderr: '/dev/null' do
  watch(%r{app/.+\.rb})
  watch(%r{lib/.+\.rb})
  watch(%r{ext/.+\.c})
end

guard(
  'rspec',
  cmd: "bundle exec rspec --drb --color -f progress",
  failed_mode: :keep,
  spec_paths: [
    'spec/unit/gitlab_client_spec.rb',
    'spec/unit/berkshelf/api/cache_builder/worker/gitlab_spec.rb'
  ],
  all_on_start: true,
  all_after_pass: true
) do
  watch(%r{^spec/unit/.+_spec\.rb$})

  watch(%r{^lib/(.+)\.rb$})           { |m| "spec/unit/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')        { "spec" }
end
