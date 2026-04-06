require 'xcodeproj'
project_path = 'FInalExam _Janasi2026.xcodeproj'
project = Xcodeproj::Project.open(project_path)
target = project.targets.first
group = project.main_group.find_subpath(File.join('FInalExam _Janasi2026'), true)

files_to_add = [
  'AnalyticsDashboardView.swift'
]

files_to_add.each do |file_name|
  file_path = File.join('FInalExam _Janasi2026', file_name)
  unless group.files.map(&:path).include?(file_name)
    file_reference = group.new_reference(file_name)
    target.add_file_references([file_reference])
    puts "Added #{file_name} to target"
  end
end

project.save
