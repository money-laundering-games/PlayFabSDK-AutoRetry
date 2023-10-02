local HttpService = game:GetService("HttpService")
local PlayFabSettings = require(script.Parent.PlayFabSettings)

local IPlayFabHttps = {}

local function GetFullUrl(urlPath)
	local fullUrl = "https://" .. PlayFabSettings.settings.titleId .. PlayFabSettings.settings.productionUrl .. urlPath
	local getParams = PlayFabSettings._internalSettings.requestGetParams
	local firstParam = true
	for key, value in pairs(getParams) do
		if firstParam then
			fullUrl ..= "?"
			firstParam = false
		else
			fullUrl ..= "&"
		end

		fullUrl ..= key .. "=" .. value
	end

	return fullUrl
end

function IPlayFabHttps.MakePlayFabApiCall(path, requestBody, authKey, authValue, onSuccess)
    local fullUrl = GetFullUrl(path)
    local encodedBody = HttpService:JSONEncode(requestBody)
    local headers = {
        ["X-ReportErrorAsSuccess"] = "true",
        ["X-PlayFabSDK"] = PlayFabSettings._internalSettings.sdkVersionString,
        ["Content-Type"] = "application/json",
    }

    if authKey and authValue ~= "" and authValue then
        headers[authKey] = authValue
    end

    local success, response = pcall(HttpService.RequestAsync, HttpService, {
        Url = fullUrl,
        Method = "POST",
        Headers = headers,
        Body = encodedBody,
    })

    if success then
        if response.Success then
            local responseBody = HttpService:JSONDecode(response.Body)
            if responseBody and responseBody.code == 200 and responseBody.data then
                onSuccess(responseBody.data)
            else
                warn("Error: " .. tostring(response) .. " retrying in 0.5s")
                task.wait(0.5)
                onSuccess(IPlayFabHttps.MakePlayFabApiCall(path, requestBody, authKey, authValue, onSuccess))
            end
        else
            warn("Error: " .. tostring(response) .. " retrying in 0.5s")
            task.wait(0.5)
            onSuccess(IPlayFabHttps.MakePlayFabApiCall(path, requestBody, authKey, authValue, onSuccess))
        end
    else
        warn("Error: " .. tostring(response) .. " retrying in 0.5s")
        task.wait(0.5)
        onSuccess(IPlayFabHttps.MakePlayFabApiCall(path, requestBody, authKey, authValue, onSuccess))
    end
end

return IPlayFabHttps