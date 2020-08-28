if File.readable?("REVISION")
  CurrentCommit = File.read("REVISION").strip
else
  CurrentCommit = `git rev-parse --short HEAD`.chomp
end
