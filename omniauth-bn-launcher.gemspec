
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require File.expand_path('../lib/omniauth-bn-launcher/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "omniauth-bn-launcher"
  spec.version       = OmniAuth::Bn::Launcher::VERSION
  spec.authors       = ["bruckwubete"]
  spec.email         = ["bruckwendwessenwubet@cmail.carleton.ca"]

  spec.summary       = "Blindside Networks auth launcher"
  spec.description   = "A ruby gem for auth integration of Blindside Networks customers"
  spec.homepage      = "https://github.com/blindsidenetworks/omniauth-bn-launcher.git"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_runtime_dependency 'omniauth', '~> 2.1', '>= 2.1.0'
  spec.add_runtime_dependency 'omniauth-oauth2', '1.7.2'
  spec.test_files    = Dir['spec/**/*.rb']
end
