%w(
  mackerel
).each do |recipe|
  include_recipe "../cookbooks/#{recipe}/default.rb"
end
