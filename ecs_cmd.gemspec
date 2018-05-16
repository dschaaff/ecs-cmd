
# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ecs_cmd/version'

Gem::Specification.new do |spec|
  spec.name          = 'ecs_cmd'
  spec.version       = EcsCmd::VERSION
  spec.authors       = ['Daniel Schaaff']
  spec.email         = ['daniel.schaaff@verve.com']

  spec.summary       = 'AWS ECS CLI UItility'
  spec.description   = 'AWS ECS CLI Utility'
  spec.homepage      = "https://danielschaaff.com"
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   << 'ecs-cmd'
  spec.require_paths = ['lib']
  spec.add_runtime_dependency 'aws-sdk'
  spec.add_runtime_dependency 'gli', '2.17.1'
  spec.add_runtime_dependency 'terminal-table'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
