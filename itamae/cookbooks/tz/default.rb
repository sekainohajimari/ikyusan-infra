case node['tz']
when 'jst'
  execute "Change localtime to JST" do
    user "root"
    command "cp -fa /usr/share/zoneinfo/Japan /etc/localtime"
  end
when 'utc'
  execute "Change localtime to UTC" do
    user "root"
    command "cp -fa /usr/share/zoneinfo/UTC /etc/localtime"
  end
end
