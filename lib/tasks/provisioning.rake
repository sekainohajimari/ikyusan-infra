namespace :provisioning do
  desc "Run provisioning apply. Ex: INFRA_ENV=development rake provisioning:apply"
  task :apply do
    bootstrap
  end

  desc "Run provisioning drurun. Ex: INFRA_ENV=development rake provisioning:apply"
  task :dryrun do
    bootstrap(dryrun: true)
  end

  def bootstrap(dryrun: false)
    options = {
      user: Global.ssh.user,
      ssh_key: Global.ssh.key,
      target: "#{itamae_dir}/entrypoint.rb",
      node: "#{itamae_dir}/nodes/#{$infra_env}.yml"
    }

    case $infra_env
    when 'development'
      development(options, dryrun: dryrun)
    when 'production'
      production(options, dryrun: dryrun)
    end
  end

  def development(options = {}, dryrun: false)
    command = "bundle exec itamae ssh -h #{Global.ssh.host} -u #{options[:user]} #{options[:target]} -y #{options[:node]}"
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
      region: Global.secret.aws.region,
      credentials: Aws::Credentials.new(
        Global.secret.aws.access_key_id,
        Global.secret.aws.secret_access_key
      )
    }
    ec2 = Aws::EC2::Client.new

    [].tap do |result|
      ec2.describe_instances.reservations.each do |reservation|
        reservation.instances.each do |instance|
          is_target = true
          instance.tags.each do |tag|
            if tag.key == 'Env' && tag.value != $infra_env
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
