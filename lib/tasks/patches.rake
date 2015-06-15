namespace :patches do
  desc "Run Patches"
  task :run, [:environment] do |t, args|
    Patches::Runner.new.run
  end

  task :pending, [:environment] do |t, args|
    Patches::Pending.each do |patch|
c     puts patch
    end
  end
end

Rake::Task['db:migrate'].enhance(['patches:run'])
