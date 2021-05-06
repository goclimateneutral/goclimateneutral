# frozen_string_literal: true

require 'guard/compat/plugin'

module ::Guard
  class Eslint < Plugin
    def run_on_additions(paths)
      run(paths)
    end

    def run_on_modifications(paths)
      run(paths)
    end

    private

    def run(paths)
      return if paths.empty?

      paths_string = paths.join(' ')
      UI.info("Inspecting Javascript code style: #{paths_string}")
      throw(:task_has_failed) unless system("bin/yarn run --silent eslint #{paths_string}")
      UI.info('ESLint found no errors or warnings')
    end
  end
end

group :ruby, halt_on_fail: true do
  guard :rspec, cmd: 'bin/rspec --format doc --no-profile' do
    require 'guard/rspec/dsl'
    dsl = Guard::RSpec::Dsl.new(self)

    # RSpec files
    rspec = dsl.rspec
    watch(rspec.spec_files)

    # Ruby files
    ruby = dsl.ruby
    dsl.watch_spec_files_for(ruby.lib_files)

    # Rails files
    rails = dsl.rails(view_extensions: %w[erb])
    dsl.watch_spec_files_for(rails.app_files)

    watch(rails.controllers) { |m| rspec.spec.call("requests/#{m[1]}") }
  end

  guard :rubocop, all_on_start: false, keep_failed: false, cli: '--extra-details --display-style-guide' do
    watch(/.+\.rb$/)
    watch(/.+\.rake$/)
    watch('Gemfile')
    watch('Rakefile')
    watch(%r{(?:.+/)?\.rubocop.yml$}) { |m| File.dirname(m[0]) }
  end
end

group :javascript do
  guard :eslint do
    watch(/^app.+\.js/)
    watch(/^config.+\.js/)
  end
end

guard :brakeman, run_on_start: false do
  watch(%r{^app/.+\.(erb|haml|rhtml|rb)$})
  watch(%r{^config/.+\.rb$})
  watch('Gemfile')
end
