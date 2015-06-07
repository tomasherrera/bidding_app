if @errors.length == 0
  json.result "success"
else
  json.result "error"
  json.errors @errors
end