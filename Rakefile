desc "Run all the specs"
task :spec do
  #sh "env COCOAPODS_VERBOSE=1 bundle exec bacon #{FileList['spec/*_spec.rb'].join(' ')}"
  sh "bundle exec bacon #{FileList['spec/*_spec.rb'].join(' ')}"
end
task :default => :spec
