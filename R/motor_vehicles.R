url <- "https://ws.cso.ie/public/api.jsonrpc"

body <- '
{
	"jsonrpc": "2.0",
	"method": "PxStat.Data.Cube_API.ReadDataset",
	"params": {
		"class": "query",
		"id": [
			"STATISTIC",
			"C02172V02618"
		],
		"dimension": {
			"STATISTIC": {
				"category": {
					"index": [
						"TEM21C01"
					]
				}
			},
			"C02172V02618": {
				"category": {
					"index": [
						"01"
					]
				}
			}
		},
		"extension": {
			"pivot": null,
			"codes": false,
			"language": {
				"code": "en"
			},
			"format": {
				"type": "JSON-stat",
				"version": "2.0"
			},
			"matrix": "TEM21"
		},
		"version": "2.0"
	}
}
'

response <- httr::POST(url = url, body = body, encode = "json")
json_data <- rawToChar(response[["content"]])
temp_json <- jsonlite::fromJSON(json_data)
json_data <- jsonlite::toJSON(temp_json$result, auto_unbox = TRUE)

new_vehicles <- rjstat::fromJSONstat(json_data)

new_vehicles$date <- lubridate::ym(new_vehicles$Month)
# new_vehicles$date <- format(lubridate::ym(new_vehicles$Month), "%d/%m/%Y")
new_vehicles <- subset(new_vehicles, select = c(date, value))
write.csv(new_vehicles, "new_vehicles.csv", row.names = FALSE)

openxlsx::write.xlsx(new_vehicles, "new_vehicles.xlsx")
