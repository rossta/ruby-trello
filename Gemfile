source 'https://rubygems.org'

active_model_version = ENV['ACTIVE_MODEL_VERSION']
gem 'activemodel', active_model_version if active_model_version

gemspec

group :development, :spec do
  gem 'jruby-openssl', :platforms => :jruby
  gem 'rake'
  gem 'rspec', '~> 3.3.0'
  gem 'simplecov', :require => false, :platforms => [:mri, :mri_18, :mri_19, :jruby, :mingw]
  gem 'webmock'
  gem 'rubocop'
end
