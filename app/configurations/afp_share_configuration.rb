class AfpShareConfiguration < Configuration
  config_file 'afp.conf'

  def render
    @shares = load_shares
    template.result binding
  end

private

  def load_shares
    SharedFolderService.where(service_class: 'AfpShareService')
  end

  def template
    ERB.new File.read(__FILE__).split("__END__\n").last
  end
end

__END__

<% @shares.each do |share| %>
[<%= share.shared_folder.name %>]
  path = <%= share.shared_folder.path %>
  time machine = <%= share.options[:time_machine] == true ? 'yes' : 'no' %>
<% end %>
