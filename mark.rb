#!/usr/bin/env ruby

BASE_FOLDER = './base'
SUBMISSIONS_FOLDER = './submissions'
MODE_FOLDER = './modes'
TMP_FOLDER = './tmp'

if ARGV.length == 0 || ARGV[0] == "help"
  puts "Usage: mark.rb [uid [a|b|c|d|e] | help ]"
  puts 
  puts "\t a: Single_Globe_In_Orbit"
  puts "\t b: Dual_Globes_In_Orbit"
  puts "\t c: Dual_Globes_In_Orbit_Fast"
  puts "\t d: Globe_Grid_In_Centre"
  puts "\t e: Globe_Grid_Drifting"

  exit 1
end

uid = ARGV[0]

if ARGV.length == 2
  mode = ARGV[1]
else
  mode = 'a'
end

if !mode.match(/[a-e]/)
  puts "Invalid mode"
  exit 1
end

file_path = nil

Dir.glob("#{SUBMISSIONS_FOLDER}/*.zip") do |d|
  if d.match(/#{uid}_.*\.zip/)
    file_path = d
    break
  end
end

if file_path == nil
  puts "Unable to find zip file"
  exit 1
end

puts "Processing #{uid}"
puts "Unzipping...."

`rm -rf #{TMP_FOLDER}`
`mkdir -p #{TMP_FOLDER}`
puts `unzip #{file_path} -d #{TMP_FOLDER}`

puts "Unzip Complete"

puts "Finding root package"

structure_flag = false
report_flag = false
report_path = nil
package_path = nil

Dir.glob("#{TMP_FOLDER}/**/*") do |d|
  if d == "./tmp/Student_Packages"
    structure_flag = true
  end

  if d == "./tmp/Report.pdf"
    report_flag == true
  end

  if d.match("./tmp/Student_Packages/vehicle_message_type.ads")
    package_path = d
    package_path = package_path.gsub("vehicle_message_type.ads", "")
  end

  if d.match(".*pdf")
    report_path = d
  end
end

if !report_path
  puts "Report not found"
end

if !package_path
  puts "Package not found.. Exiting..."
  exit 1
end

if !structure_flag
  puts "Incorrect zip structure detected"
end

if !report_flag
  puts "Incorrect report name detected"
end

puts "Report Found at: #{report_path}"
puts "Package Root found at: #{package_path}"

puts "Linking Package"

`rm #{BASE_FOLDER}/Sources/Student_Packages`
`ln -s #{package_path} #{BASE_FOLDER}/Sources/Student_Packages`

puts "Linking Compete"

puts "Setting Mode to: #{mode.upcase}"

`cp #{MODE_FOLDER}/#{mode} #{BASE_FOLDER}/Sources/Swarm/swarm_configuration.ads`

puts "Mode Setup Complete"

puts "Opening GPS and Report"

Process.fork do 
  exec("open #{report_path}")
end

Process.fork do
  exec("gps -P ./base/swarm_mac_os.gpr")
end

puts "Project Setup Complete!"

