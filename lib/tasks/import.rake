ENV['RAILS_ENV'] ||= 'development'
require File.expand_path('../../../config/environment', __FILE__)

namespace :import do
  desc "imports the documents"
  task :doc, [:folder] do |task, args|
    user = User.find_or_initialize_by(email: 'jc7v@riseup.net')
    user.password = 'password'
    user.save!
    puts "Creating or using user: #{user.email}"
    Dir[File.join(args[:folder], '**', '*')].each do |file|
      next if File.directory?(file)
      filename = file.split('/').last
      doc = Document.new
      doc.doc_asset.attach(io: File.open(file), filename: filename)
      doc.user = user
      doc.populate_from_asset
      puts "Creating a document from file: #{filename} with title: #{doc.title}"
      doc.save!
    end
  end

end
