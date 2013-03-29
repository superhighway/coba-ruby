require 'fileutils'
require 'maruku'

desc "Build HTML pages"
task :build_pages do
	input_folder = 'tingkat/'
  input_extension = '.md'
	output_folder = 'build/'
	output_extension = '.html'

	Dir["#{input_folder}*/*#{input_extension}"].each do |input_file_name|
		output_file_name = input_file_name.sub(input_folder, output_folder)
		output_file_name.sub!(input_extension, output_extension)

		FileUtils.mkdir_p output_file_name.split('/')[0...-1].join('/')

    content = File.read input_file_name
    puts "Converting Markdown to HTML: #{input_file_name} => #{output_file_name}"
		File.open(output_file_name, 'w') do |f|
			f.write Maruku.new(content).to_html
		end
	end
end

desc "Push HTML pages to GitHub"
task :push_pages do
	remote = 'https://github.com/catcyborg/tingkat-coba-ruby-draft.git'
	branch = 'gh-pages'

	`cd build;
	git init;
	git add .;
	git remote add origin #{remote};
	git commit -am 'Update at #{Time.now}';
	git checkout -b #{branch};
	git rebase master;
	git push -u origin #{branch}`
end
