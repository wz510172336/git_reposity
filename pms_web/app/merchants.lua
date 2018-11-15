local json = require "cjson"
local client = require "resty.kafka.client"
local producer = require "resty.kafka.producer"


local broker_list = {
	{ host = "127.0.0.1", port = 9092 },
}

local request_method = ngx.var.request_method
local args = nil
if "GET" == request_method then
    ngx.say("get请求")
    args = ngx.req.get_uri_args()
    for k,v in pairs(args) do
    	ngx.say("[GET] key:", k, " v:", v)
    end
elseif "POST" == request_method then
    ngx.say("post请求")
    args = ngx.req.get_body_data()
    ngx.say(args)
end

local cli = client:new(broker_list)
local brokers, partitions = cli:fetch_metadata("test")
if not brokers then
    ngx.say("fetch_metadata failed, err:", partitions)
end
--[[ngx.say("brokers: ", json.encode(brokers), "; partitions: ", json.encode(partitions))]]

local bp = producer:new(broker_list, { producer_type = "async" })

local ok, err = bp:send("test", "123", args)
if not ok then
    ngx.say("send err:", err)
    return
end
ngx.say("send success, ok:", ok)