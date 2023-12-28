require_relative "lib/api/version"

Gem::Specification.new do |spec|
  spec.name = "api"
  spec.version = Api::VERSION
  spec.authors = ["Aram"]
  spec.email = ["aramhrptn@hotmail.com"]
  spec.homepage = "https://github.com/urumo/experiments_api"
  spec.summary = "The API for the experiments app."
  spec.description = "This is the API for experiments app core, which is going to be mounted into the main app."

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.1.2"
  spec.add_development_dependency "rspec-rails"
end
