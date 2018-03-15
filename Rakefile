# frozen_string_literal: true

task :cukes do
  system('bundle exec cucumber') || raise('Cukes failed')
end

task :specs do
  system('bundle exec rspec') || raise('Specs failed')
end

task :rubocop do
  system('bundle exec rubocop') || raise('Cops failed')
end

task default: %i[rubocop specs cukes]
