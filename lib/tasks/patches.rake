namespace :patches do
  desc "Run Patches"
  task :run => [:environment] do
    Patches::Runner.new.perform
  end

  task :pending => [:environment] do
    Patches::Pending.each do |patch|
      puts patch
    end
  end
end
