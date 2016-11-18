--[[
-- Library for RIPE Atlas API v2
-- (c) 2016-2017 Leonardo Arena <rnalrd at gmail dot com>
--
-- This software is provided "as is" without any implicit or explicit warranty
-- Use it at your own risk
]]--

-- TODO: Use curl library

local ratlas = {}
local cjson = require("cjson")
--local cURL = require("cURL")

local base_url = "https://atlas.ripe.net/api/v2/"

local function exit_if_null(param)
  if param == nil then
    os.exit(1)
  end
end

local function fetch_results(url)
  local curl_out_file = "results.json"
  local cmd, err = assert(io.popen("curl -s"..url.." -o "..curl_out_file))
  cmd:close()

  local f, err = assert(io.open(curl_out_file))
  local f_content = f:read "*a"
  f:close()

  return f_content
end

local function cjson_decode(url)
  print("running ratlas")
  --[[
  o_curl = cURL.easy {
    url = base_url.."measurements/"..measurement_id.."/results"
  }
  f_content = o_curl:perform()
  ]]--
  t_json, pos, err = cjson.decode(fetch_results(url))
  if err then
    print("Error: ", err)
  else
    return t_json
  end
end

local function status_check(measurement_id,what)
  exit_if_null(measurement_id)
	
  local url = base_url.."measurements/"..measurement_id.."/status-check"
  local t_json = cjson_decode(url)

  if what == nil then
    return t_json
  else
    return t_json[what]
  end
end

return {
  status_check = status_check
}
