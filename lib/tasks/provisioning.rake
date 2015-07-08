namespace :provisioning do
  desc "Run provisioning apply"
  task :apply do
    bootstrap
  end

  desc "Run provisioning drurun"
  task :dryrun do
    bootstrap(dryrun: true)
  end

  def bootstrap(dryrun: false)
    options = {
      user: ENV['SSH_USER'],
      ssh_key: ENV['SSH_KEY'],
      target: "#{itamae_dir}/entrypoint.rb",
      node: "#{itamae_dir}/nodes/#{ENV['INFRA_ENV']}.yml"
    }

    case ENV['INFRA_ENV']
    when 'development'
      development(options, dryrun: dryrun)
    when 'production'
      production(options, dryrun: dryrun)
    end
  end

  def development(options = {}, dryrun: false)
    host = ENV['HOST']

    command = "bundle exec itamae ssh -h #{host} -u #{options[:user]} #{options[:target]} -y #{options[:node]}"
    command += ' -n' if dryrun

    sh command
  end

  def production(options = {}, dryrun: false)
    Parallel.each(ec2_hosts, in_threads: 2) do |host|
      puts "target host is #{host}"

      command = "bundle exec itamae ssh -h #{host} -u #{options[:user]} #{options[:target]} -y #{options[:node]} -i #{options[:ssh_key]}"
      command += ' -n' if dryrun

      sh command
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
