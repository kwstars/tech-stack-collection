REDIS_CLI=docker exec redis redis-cli

# 添加地理空间位置到 "myplaces" 键
geoadd:
	$(REDIS_CLI) GEOADD myplaces 13.361389 38.115556 "Palermo" 15.087269 37.502669 "Catania"

# 计算 "Palermo" 和 "Catania" 之间的距离
geodist:
	$(REDIS_CLI) GEODIST myplaces Palermo Catania km

# 获取 "Palermo" 和 "Catania" 的 Geohash 表示
geohash:
	$(REDIS_CLI) GEOHASH myplaces Palermo Catania

# 获取 "Palermo" 和 "Catania" 的经度和纬度
geopos:
	$(REDIS_CLI) GEOPOS myplaces Palermo Catania

# 查询在 myplaces 键中，以经度 15 和纬度 37 为中心，半径为 100 公里的范围内的地理位置元素，并返回它们的距离。
georadius:
	$(REDIS_CLI) GEORADIUS myplaces 15 37 100 km WITHDIST

# 在 myplaces 键中，以 "Palermo" 为中心，半径为 100 公里的范围内的地理位置元素。
georadiusbymember:
	$(REDIS_CLI) GEORADIUSBYMEMBER myplaces Palermo 100 km
