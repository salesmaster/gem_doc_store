require "bundler/gem_tasks"

namespace :test do
  task :lib do
    Dir.glob("test/lib/*.rb").each do |file|
      puts "\nRunning : #{file}"
      system("ruby #{file}")
    end
  end
end