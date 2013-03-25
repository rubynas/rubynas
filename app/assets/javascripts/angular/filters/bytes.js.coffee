angular.module('bytes', []).
  filter 'bytes', () ->
    UNIT = 1000
    KB = UNIT
    MB = KB * UNIT
    GB = MB * UNIT
    TB = GB * UNIT
    
    (bytes) ->
      if bytes <= MB
        "#{Math.ceil(bytes / KB)} KB"
      else if bytes <= GB
        "#{Math.ceil(bytes / MB)} MB"
      else if bytes <= TB
        "#{Math.ceil(bytes / GB)} GB"
      else
        "#{Math.ceil(bytes / TB)} TB"
