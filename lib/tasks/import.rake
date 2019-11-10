ENV['RAILS_ENV'] ||= 'development'
require File.expand_path('../../../config/environment', __FILE__)

namespace :import do
  desc "imports the documents"
  task :doc, [:folder] do |task, args|
    user = User.find_or_initialize_by(email: 'importer@user.com')
    user.password = 'password'
    user.save!
    puts "Creating user: #{user}"
    Dir[File.join(args[:folder], '**', '*')].each do |file|
      next if File.directory?(file)
      doc = Document.new(
          description: Faker::Lorem.sentences,
          author: Faker::Name.name,
          number_of_pages: rand(0..100),
          realized_at: Faker::Date.backward,
          hits: rand(0..500),
          status: :refused,
          user: user
      )
      filename = file.split('/').last
      doc.title = filename
      doc.doc_asset.attach(io: File.open(file), filename: filename)
      puts "Creating a document from file: #{file} with file name: #{filename}"
      doc.save!
    end
  end

end
