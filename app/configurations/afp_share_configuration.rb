class AfpShareConfiguration < Configuration
  config_file 'afp.conf'

  def time_machine(share)
    share.options[self][:time_machine] ? 'yes' : 'no'
  end
end
