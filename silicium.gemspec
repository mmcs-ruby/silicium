lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "silicium/version"

Gem::Specification.new do |spec|
  spec.name          = "silicium"
  spec.version       = Silicium::VERSION
  spec.authors       = ["mmcs-ruby"]
  spec.email         = ["poganesyan@sfedu.ru"]

  spec.summary       = %q{Ruby math library made as exercise by MMCS students .}
  spec.description   = %q{Long list of applied functions}
 # spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

=begin

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage

  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."
=end
  spec.metadata["source_code_uri"] = 'https://github.com/mmcs-ruby/silicium'
  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency 'simplecov'
end
