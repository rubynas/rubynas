window.SystemSummaryController = ($scope, $http, User, Volume) ->
  $scope.users = User.query()

  # disks
  $scope.disks = Volume.query()
  
  # Map all cpus to a single value
  mapCpus = (cpus) ->
    data =
      idle: 0
      nice: 0
      system: 0
      user: 0
    
    cpus.forEach (cpu) ->
      data.idle += cpu.idle
      data.nice += cpu.nice
      data.system += cpu.system
      data.user += cpu.user
  
    sum = data.idle + data.nice + data.system + data.user
    data.system = ((data.system / sum) * 100.0) + "%"
    data.user = (((data.user + data.nice) / sum) * 100.0) + "%"
    data
  
  updateVmstat = () ->
    $http.get('/api/system/vmstat').success (vmstat) ->
      # load
      $scope.load = vmstat.load_average
      
      # boottime
      $scope.boot_time = vmstat.boot_time
      
      # Create cpu progress bar
      $scope.cpu = mapCpus(vmstat.cpus)
      $scope.cpus = vmstat.cpus.length
      
      # Create memory progress bar
      memory = vmstat.memory
      free = memory.free * memory.pagesize
      used = (memory.wired + memory.active + memory.inactive) * memory.pagesize
      $scope.memory =
        usedPercent: (used / (free + used) * 100.0) + '%'
        usedBytes: used
        totalBytes: free + used
        
      # Create nics
      $scope.nics = vmstat.network_interfaces
  
  # update after load
  updateVmstat()
  
  # setup update interval
  setInterval updateVmstat, 5000
