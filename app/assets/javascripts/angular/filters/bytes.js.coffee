angular.module('bytes', [])
  .filter 'bytes', () ->
    UNIT = 1000
    KB = UNIT
    MB = KB * UNIT
    GB = MB * UNIT
    TB = GB * UNIT
    
    formatFloat = (val) ->
      Math.ceil(val * 100) / 100
        
    (bytes) ->
      if bytes <= MB
        "#{formatFloat(bytes / KB)} KB"
      else if bytes <= GB
        "#{formatFloat(bytes / MB)} MB"
      else if bytes <= TB
        "#{formatFloat(bytes / GB)} GB"
      else
        "#{formatFloat(bytes / TB)} TB"
  .filter 'number', () ->
    (val) ->
      Math.ceil(val * 100) / 100