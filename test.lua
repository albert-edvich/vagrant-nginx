local mysql = require "resty.mysql"

local account_name = ""
local app_key_rules = {[""] = 1, [""] = 1}
local mrum_multiplier = 5000
local limit = 14 * mrum_multiplier
local db, err = mysql:new()

if not db then
  ngx.log(ngx.ERR, "failed to instantiate mysql: ", err)
  return
end

db:set_timeout(1000)

local ok, err, errcode, sqlstate = db:connect{
  host = "127.0.0.1",
  port = 3388,
  database = "eum_db",
  user = "root",
  password = "",
  charset = "utf8",
  max_packet_size = 1024 * 1024,
}

if not ok then
  ngx.log(ngx.ERR, "failed to connect: ", err, ": ", errcode, " ", sqlstate)
  return
end

account, err, errcode, sqlstate =
  db:query("SELECT * FROM accounts WHERE account_name = " .. ngx.quote_sql_str(account_name))
if not account then
  ngx.log(ngx.ERR, "bad result: ", err, ": ", errcode, ": ", sqlstate, ".")
  return
end

res, err, errcode, sqlstate =
  db:query("SELECT registered_agents FROM mobile_license_usage WHERE account_name = " .. ngx.quote_sql_str(account_name))
if not res then
  ngx.log(ngx.ERR, "bad result: ", err, ": ", errcode, ": ", sqlstate, ".")
  return
end

agent_ms = ngx.req.get_headers()["mat"]
app_key = ngx.req.get_headers()["ky"]
if agent_ms ~= account[1]["mobile_current_billing_cycle_start_date_ms"] then
  if app_key then
    exists = app_key_rules[app_key]
    usage = res[1]["registered_agents"]
    units = account[1]["mobile_license_units_allocated"]
    current = tonumber(units) * mrum_multiplier - tonumber(usage)
    ngx.log(ngx.ERR, "App Key ", app_key, " limit ", limit, " exists = ", exists, " usage = ", usage, " units = ", units, " current = ", current)
    if exists and tonumber(usage) >= limit then
      ngx.log(ngx.ERR, "App Key ", app_key, " reached the limit ", allowed)
      ngx.status = ngx.HTTP_OK
      ngx.header["Content-Type"] = "application/json"
      ngx.say("{}")
      return ngx.exit(ngx.HTTP_OK)
    end
  end
end

local ok, err = db:set_keepalive(10000, 100)
if not ok then
  ngx.say("failed to set keepalive: ", err)
  return
end

-- local ok, err = db:close()
-- if not ok then
--     ngx.log(ngx.ERR, "failed to close: ", err)
--     return
-- end
