namespace :provisioning do
  desc "Run provisioning apply"
  task :apply do
    target = "#{itamae_dir}/entrypoint.rb"
    node = "#{itamae_dir}/nodes/#{ENV['INFRA_ENV']}.yml"

    if ENV['INFRA_ENV'] == 'development'
      host = ENV['HOST']
      user = ENV['SSH_USER']

      sh "bundle exec itamae ssh -h #{host} -u #{user} #{target} -y #{node}"
    elsif ENV['INFRA_ENV'] == 'production'
      # EC2のホストを取得
      # pallarelで
      # itamaeコマンドを実行する
    end
  end

  desc "Run provisioning drurun"
  task :dryrun do
  end

  def itamae_dir
    File.expand_path('../../../itamae', __FILE__)
  end
end
