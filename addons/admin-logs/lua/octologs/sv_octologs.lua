require('gwsockets')
octologs = octologs or {}
octologs.logsQueue = octologs.logsQueue or {}
octologs.logsFailed = {}
octologs.lastLogTime = 0
local settings = {}
local webhooks = {
'https://discord.com/api/webhooks/1173850863052267581/CUTNx8rIYv-P5H5FKdFUg5ZXLxcuP6RkZ4chDeJjrPdk0kKG7i6F8drCWW-mGHxtiqCl',
'https://discord.com/api/webhooks/1173850989086920784/Zu_YIrEZ7aG207ZiwPBJ8AnC6-aSoyjCPoIZb8prWPIxorB_jVsPTRqxU8ALTVomPq1H',
'https://discord.com/api/webhooks/1173851048289513584/Rl1Jvr2DHgYAbewTvuAks_ubQeWv0t5JKHTjhEAxsUxeyocWb_6poiJkbkqZP70IFDRg',
'https://discord.com/api/webhooks/1173851137754026034/TSafFq2FC42q_vRdeGtQ6BzbWraDRrAwtWFJ0rlgHGQDBBNVzRBmVVh2z7_tAed4Lz7G',
'https://discord.com/api/webhooks/1173851384588816464/vkaCDAwkwyDa2AEMGskgVGj5FhsHPdghHLn_gaGVGquM6vfkXBV8dwskjU3l6ty7R-DC',
'https://discord.com/api/webhooks/1173851484681682974/MRHgTR9YyAJIyqB8GLmr30VVLtSInXm4SyDCvmR_TbHccDFAPtF7p9DKgD2zkSh-KiPf',
'https://discord.com/api/webhooks/1173851724822368347/4UKpEelrivUJInWN9cm075YR7alaZRnrLbu5E1A4rdV-NGeo8fFkkQpzAHaRMl1hJJSq',
'https://discord.com/api/webhooks/1173907165438820382/3l0YXHZIgUtqyrklFn5-J4EEkteq3tEOGl854m6GG7pA3-kkIevcWwWb0mntwk3ckoCl',
'https://discord.com/api/webhooks/1173907273597337660/50H3WB1TcPb72ysuyKAK3sL4zNWjCnWisPvyeeBplY8fJ-ES_wNohlKemjf9wraWnIOK',
'https://discord.com/api/webhooks/1173881495547555920/iyjpwRAaSoO2exNxChMKOTG6-n1KbGydewTBHpWt349O8sUHPtMVzWZs6q84WBxX-IIs',
'https://discord.com/api/webhooks/1173907408628760646/43g92FPkwoRNa3MqMoyuekhumsEnBL64KX30WqFwtPyK76yjjmzqBGnHb1uWqJsQWBSa',
}

local colors = {
	14073361,
	8275331,
	12755712,
	2417643,
	12452150,
	6244388,
	567842,
	2102201,
	6513507,
	7798784,
	2250,
	11337839,
	12479506,
	511863,
}

--------------------------
-- CATEGORY DEFINITIONS --
for i=0,13 do
	table.insert(settings,i,{})
	settings[i].webhook = webhooks[i+1]
	settings[i].color = colors[i+1]
end
--------------------------

--------------------------
-- CATEGORY DEFINITIONS --
octologs.CAT_OTHER = 0
octologs.CAT_ADMIN = 1
octologs.CAT_DONATE = 2
octologs.CAT_BUILD = 3
octologs.CAT_DAMAGE = 4
octologs.CAT_INVENTORY = 5
octologs.CAT_SHOP = 6
octologs.CAT_POLICE = 7
octologs.CAT_PROPERTY = 8
octologs.CAT_LOCKPICK = 9
octologs.CAT_CUFF = 10
octologs.CAT_KARMA = 11
octologs.CAT_GMPANEL = 12
octologs.CAT_VEHICLE = 13
-------------------------- 

octologs.api = octolib.api({
	url = 'https://octothorp.team/logs/api',
	headers = { ['Authorization'] = CFG.keys.logs },
})

local function unpackNestedTables(log, depth)
    local unpackedLog = {}

    for _, v in ipairs(log) do
        if type(v) == "table" and depth < 15 then
            local nestedLog = unpackNestedTables(v, depth + 1)
            for _, value in ipairs(nestedLog) do
                table.insert(unpackedLog, value)
            end
        else
            table.insert(unpackedLog, v)
        end
    end

    return unpackedLog
end

function octologs.log(message, category)
	category = category or octologs.CAT_OTHER
	local currentTime = os.time()
	local unpackedLog = unpackNestedTables(message, 2)
	local steamID = message[1][2]['ply'] or ""
	-- Печать распакованных значений
	local sendlg =""
	for _, value in ipairs(unpackedLog) do
    	sendlg = sendlg .. value
		sendlg = sendlg .. " "
	end
	sendlg = "(" .. steamID .. ") " .. sendlg
	if CurTime() - octologs.lastLogTime < 0.5 and octologs.lastLog == sendlg then return end
	print(sendlg)
	HTTP({
		method = "post",
		type = "application/json; charset=utf-8",
		headers = {
			["User-Agent"] = "Discord Chat Relay",
		},
		url = settings[category].webhook,
		body  = util.TableToJSON({
			content = null,
			embeds = {
				{
					description = sendlg,
					color = settings[category].color,
					footer = {
						text = "[".. os.date("%H:%M:%S", currentTime) .. "]"
					},
				},
			},
		}),
		failed = function(error)
			MsgC(Red, "Discord API HTTP Error:", White, error, "\n")
		end,
		success = function(code, response)
			if code ~= 204 then
				MsgC(Red, "Discord API HTTP Error:", White, code, response, "\n")
			end
		end
	})
	file.Append("logs.txt", sendlg .. "\n")

	octologs.lastLog = sendlg
	octologs.lastLogTime = CurTime()

end

local failMode = false
function octologs.sendToApi()

	if #octologs.logsQueue < 1 then return end

	local toSend = octologs.logsQueue
	octologs.logsQueue = {}

end
timer.Create('octologs.sendToApi', 5, 0, octologs.sendToApi)
