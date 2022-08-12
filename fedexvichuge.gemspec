require_relative 'lib/fedexvichuge/version'

Gem::Specification.new do |spec|
  spec.name          = 'fedexvichuge'
  spec.version       = Fedexvichuge::VERSION
  spec.authors       = ['vichuge']
  spec.email         = ['victor.hugo.pacheco.flores@gmail.com']

  spec.summary       = 'Summarize your fedex packages'
  spec.description   = 'This is a test for fedexvichuge gem'
  spec.homepage      = 'https://github.com/vichuge/fedex_gem'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['allowed_push_host'] = "https://rubygems.org/"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/vichuge/fedex_gem'
  spec.metadata['changelog_uri'] = 'https://github.com/vichuge/fedex_gem'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
