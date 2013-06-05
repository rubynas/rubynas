class AfpShareConfiguration < Configuration
  config_file 'afp.conf'

  def render
    NetatalkConfig.clear
    config.each do |share_name, share_config|
      NetatalkConfig.shares[share_name] = share_config
    end
    NetatalkConfig.afp
  end

  def config
    load_shares.inject({}) do |config, share|
      config[share.shared_folder.name] = {
        'path' => share.shared_folder.path,
        'time_machine' => (share.options[:time_machine] == true)
      }
      config
    end
  end

private

  def load_shares
    SharedFolderService.where(service_class: 'AfpShareService')
  end
end
