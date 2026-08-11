File.readlines(File.join(__dir__, "key.env")).each do |line|
  key, value = line.strip.split("=", 2)
  ENV[key] = value if key && value
end