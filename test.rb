require 'mr_darcy'

MrDarcy::Promise.new do
  resolve 1
end.then do
  MrDarcy::Promise.new do
    resolve 2
  end
end.then do |v|
  puts "got #{v}"
end


sleep 10
