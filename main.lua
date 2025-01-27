-- MAKE SURE YOUR WORKING DIRECTORY IS THE ROOT OF THE PROJECT NOT `src` OR ANY OTHER FOLDER
package.path = package.path .. ";.\\target\\debug\\?.lua"
package.cpath = package.cpath .. ";.\\target\\debug\\?.dll"

local jsonrpc = require("lua_json_rpc")

local stop = jsonrpc.start_server({
    host = "127.0.0.1",
    port = 1359,
    workers = 4
})

io.write("JSON-RPC server started on port 1359\n")
io.flush()

function on_rpc(request)
    --io.write("Routing Request: " .. request.method .. "\n")

    local response = {
        id = request.id,
        jsonrpc = "2.0",
    }

    if (string.match("subtract", request.method)) then
        response.result = request.params[1] - request.params[2]
    end

    --io.flush()

    return response
end

local started = os.clock()

--while os.clock() - started < 30 do -- Run for 30 seconds
while true do
    jsonrpc.process_rpc(on_rpc)
end

print("Shutting down JSON-RPC server")
stop()

os.execute("echo Press any key to continue... && pause > nul")