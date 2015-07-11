case node['tz']
when 'jst'
  execute "Change localtime to JST" do
    user "root"
    command "cp -fa /usr/share/zoneinfo/Japan /etc/localtime"
    not_if "date | grep JST"
  end
when 'utc'
  execute "Change localtime to UTC" do
    user "root"
    command "cp -fa /usr/share/zoneinfo/UTC /etc/localtime"
    not_if "date | grep UTC"
  end
end
