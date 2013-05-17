require 'JSON'

desc "Output JSON of level list"
task :output_levels_as_json do
  list = []
  Dir['source/tingkat/*'].each do |path1|
    Dir[path1 + '/*'].each do |path2|
      list << (path2.split('source/').last.split('.md').first + '.html')
    end
  end

  File.open('source/levels.json', 'w') do |f|
    f.write JSON.generate levels: list
  end
end
