
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "zmcli/version"

Gem::Specification.new do |spec|
  spec.name          = "zmcli"
  spec.version       = Zmcli::VERSION
  spec.authors       = ["N H"]
  spec.email         = ["h.nedim@gmail.com"]

  spec.summary       = %q{Zimbra cli.}
  spec.description   = %q{Zimbra helper cli.}
  spec.homepage      = "https://github.com/inservio/zmcli"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = %w(zmcli)
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
end
