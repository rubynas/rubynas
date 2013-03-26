class Volume < ActiveRecord::Base
  attr_accessible :name, :path

  def capacity
    disk.block_size * disk.total_blocks
  end
  
  def usage
    used_bytes = (disk.total_blocks - disk.free_blocks) * disk.block_size
    used_bytes / capacity.to_f * 100
  end
  
  def disk
    Vmstat.disk(path)
  end
end
