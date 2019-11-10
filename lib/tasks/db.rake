namespace :db do
  desc 'Drop the database, create it, migrate and populate'
  task recreate: :environment do
    invoke_tasks('db', %w(drop create migrate seed))
  end

  def invoke_tasks(namespace, tasks)
    tasks.each { |task |Rake::Task["#{namespace}:#{task}"].invoke }
  end

end
