namespace :provisioning do
  desc "Run provisioning apply"
  task :apply do
    infra_env = ENV['INFRA_ENV']
    options = {
      user: ENV['SSH_USER'],
      ssh_key: ENV['SSH_KEY'],
      target: "#{itamae_dir}/entrypoint.rb",
      node: "#{itamae_dir}/nodes/#{infra_env}.yml"
    }

    case infra_env
    when 'development'
      development(options)
    when 'production'
      production(options)
    end
  end

  desc "Run provisioning drurun"
  task :dryrun do
  end

  def development(options = {})
    host = ENV['HOST']

    sh "bundle exec itamae ssh -h #{host} -u #{options[:user]} #{options[:target]} -y #{options[:node]}"
  end

  def production(options = {})
    Parallel.each(ec2_hosts, in_threads: 2) do |host|
      puts "target host is #{host}"

      sh "bundle exec itamae ssh -h #{host} -u #{options[:user]} #{options[:target]} -y #{options[:node]} -i #{options[:ssh_key]}"
    end
  end

  def itamae_dir
    File.expand_path('../../../itamae', __FILE__)
  end

  def ec2_hosts
    Aws.config[:ec2] = {
      region: 'ap-northeast-1',
      credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
    }
    ec2 = Aws::EC2::Client.new

    [].tap do |result|
      ec2.describe_instances.reservations.each do |reservation|
        reservation.instances.each do |instance|
          is_target = true
          instance.tags.each do |tag|
            if tag.key == 'Env' && tag.value != ENV['INFRA_ENV']
              is_target = false
              break
            end

            if tag.key == 'Name' && !(tag.value =~ /ikyusan-api/)
              is_target = false
              break
            end
          end

          result << instance.public_dns_name if is_target
        end
      end
    end
  end
end
