require 'JSON'

desc "Output JSON of challenge paths"
task :generate_challenge_paths do
  list = []
  Dir['source/tingkat/*'].each do |path1|
    Dir[path1 + '/*'].each do |path2|
      list << (path2.split('source/tingkat/').last.split('.md').first)
    end
  end

  File.open('source/challenge_paths.json', 'w') do |f|
    f.write JSON.generate challenge_paths: list
  end
end
