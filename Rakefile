desc "Run all the specs"
task :spec do
  sh "bundle exec bacon #{FileList['spec/*_spec.rb'].join(' ')}"
end
task :default => :spec
