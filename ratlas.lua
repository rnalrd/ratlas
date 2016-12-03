--[[
--
-- LUA Library for RIPE Atlas API v2
-- (c) 2016-2017 Leonardo Arena <rnalrd at gmail dot com>
--
-- This software is provided "as is" without any implicit or explicit warranty
-- Use it at your own risk
--
-- Usage:
--
-- Currently only status_checks[1] are implemented, and you can access only public
-- measurements. To use it in your script do:
--
--   ratlas.status_check(measurement_id,key)
--
-- where "measurement_id" (required) has the same meaning indicated at [1]
-- and "key" is optional. If "key" is not specified it will return a table
-- with the results. You can access directly a table value by specifying its "key".
--
-- E.g.
--
-- ratlas.status_check(measurement_id,global_alert)
--
-- [1] https://atlas.ripe.net/docs/api/v2/manual/measurements/status-checks.html
--
]]--

-- TODO: Don't use tmp_file

local ratlas = {}
local json = require("json")
local cURL = require("cURL")

local base_url = "https://atlas.ripe.net/api/v2/"

local function exit_if_null(param)
  if param == nil then os.exit(1) end
end

-- Unused
local function fetch_results(url)
  local curl_out_file = "results.json"
  local cmd, err = assert(io.popen("curl -s"..url.." -o "..curl_out_file))
  cmd:close()

  local f, err = assert(io.open(curl_out_file))
  local f_content = f:read "*a"
  f:close()
  os.remove(curl_out_file)

  return f_content
end

local function json_decode(url)
  print("running ratlas")
  local temp_file = "/tmp/ratlas.tmp"
  local f = assert(io.open(temp_file,"w"))
  o_curl = cURL.easy {
    url = url,
    writefunction = f
  }
  o_curl:perform()
  o_curl:close()
  f:close()
  local f = assert(io.open(temp_file))
  local result = f:read("*a")
  f:close()
  os.remove(temp_file)
  t_json, pos, err = json.decode(result)
  if err then
    print("Error: ", err)
  else
    return t_json
  end
end

local function status_check(measurement_id,key)
  exit_if_null(measurement_id)
	
  local url = base_url.."measurements/"..measurement_id.."/status-check"
  local t_json = json_decode(url)

  if key == nil then
    return t_json
  else
    return t_json[key]
  end
end

return {
  status_check = status_check
}
