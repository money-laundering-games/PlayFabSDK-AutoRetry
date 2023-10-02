-- PlayFab Events API
-- You should not require this file directly
-- All api calls are documented here: https://docs.microsoft.com/gaming/playfab/api-references/

local Promise = require(script.Parent.Promise)
local IPlayFabHttps = require(script.Parent.IPlayFabHttps)
local PlayFabSettings = require(script.Parent.PlayFabSettings)

local PlayFabEventsApi = {
    settings = PlayFabSettings.settings
}

--[[
    Write batches of entity based events to PlayStream. The namespace of the Event must be 'custom' or start with 'custom.'.
    https://docs.microsoft.com/rest/api/playfab/events/playstream-events/writeevents
--]]
function PlayFabEventsApi:WriteEvents(entityToken, request)
    return Promise.new(function(resolve, reject)
         if (not entityToken) then reject("Must provide an entityToken to call this method") end
        IPlayFabHttps.MakePlayFabApiCall("/Event/WriteEvents", request or {}, "X-EntityToken", entityToken, resolve, reject)
    end)
end

--[[
    Write batches of entity based events to as Telemetry events (bypass PlayStream). The namespace must be 'custom' or start
    with 'custom.'
    https://docs.microsoft.com/rest/api/playfab/events/playstream-events/writetelemetryevents
--]]
function PlayFabEventsApi:WriteTelemetryEvents(entityToken, request)
    return Promise.new(function(resolve, reject)
         if (not entityToken) then reject("Must provide an entityToken to call this method") end
        IPlayFabHttps.MakePlayFabApiCall("/Event/WriteTelemetryEvents", request or {}, "X-EntityToken", entityToken, resolve, reject)
    end)
end

return PlayFabEventsApi
