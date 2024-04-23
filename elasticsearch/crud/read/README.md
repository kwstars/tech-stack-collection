## 获取

```json
GET <index_name>/_doc/<id>
```

## 文档是否存在

```json
HEAD movies/_doc/1
```

## 一次获取多个文档

```json
GET movies/_mget
{
  "ids": [
    "1",
    "12",
    "19",
    "34"
  ]
}

GET classic_movies/_search
{
  "query": {
    "ids": {
      "values": [1,2,3,4]
    }
  }
}
```

## 从多个索引获取文档

```json
GET _mget
{
  "docs":[
   {
     "_index":"classic_movies",
     "_id":11
   },
   {
     "_index":"international_movies",
     "_id":22
   },
   {
     "_index":"top100_movies",
     "_id":33
   }
  ]
}

GET classic_movies,international_movies/_search
{
  # body
}
```

## 返回没有元数据的原始文档

```json
GET movies/_source/1
```

## 只返回元数据

```json
GET movies/_doc/1?_source=false
```

## 包括和排除字段

```json
# 在 "movies" 索引中以 ID 3 索引一个新文档
PUT movies/_doc/3
{
  "title": "The Shawshank Redemption",
  "synopsis": "Two imprisoned men bond ..",
  "rating": 9.3,
  "certificate": "15",
  "genre": "drama",
  "actors": [
    "Morgan Freeman",
    "Tim Robbins"
  ]
}

# 检索特定字段（title，rating，genre）
GET movies/_doc/3?_source_includes=title,rating,genre

# 索特定字段（title，rating，genre）
GET movies/_source/3?_source_includes=title,rating,genre

# 索特定字段，排除 actors 和 synopsis
GET movies/_source/3?_source_excludes=actors,synopsis

PUT movies/_doc/13
{
  "title": "Avatar",
  "rating": 9.3,
  "rating_amazon": 4.5,
  "rating_rotten_tomatoes": 80,
  "rating_metacritic": 90
}

# 检索所有以 "rating" 开头的字段，但排除 "rating_amazon"
GET movies/_source/13?_source_includes=rating*&_source_excludes=rating_amazon
```

## [Bulk API](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-bulk.html)

```json
# 创建多个文档
POST movies/_bulk
{"index":{}}
{"title": "Mission Impossible","release_date": "1996-07-05"}
{"index":{}}
{"title": "Mission Impossible II","release_date": "2000-05-24"}
{"index":{}}
{"title": "Mission Impossible III","release_date": "2006-05-03"}
{"index":{}}
{"title": "Mission Impossible - Ghost Protocol","release_date": "2011-12-26"}

# 创建一个新的电影文档
POST _bulk
{"index":{"_index":"movies","_id":"200"}}
{"doc": {"director":"Brett Ratner"}}

# 更新电影文档
POST _bulk
{"update":{"_index":"movies","_id":"200"}}
{"doc": {"director":"Brett Ratner", "actors":["Jackie Chan","Chris Tucker"]}}

# 在 "books" 索引中添加一个文档，创建一个具有指定 ID 的 "flights" 索引文档，向 "pets" 索引添加一个文档，删除 "movies" 索引中的一个文档，以及更新 "movies" 索引中的一个文档的标题。
POST _bulk
{"index":{"_index":"books"}}
{"title": "Elasticsearch in Action"}
{"create":{"_index":"flights", "_id":"101"}}
{"title": "London to Bucharest"}
{"index":{"_index":"pets"}}
{"name": "Milly","age_months": 18}
{"delete":{"_index":"movies", "_id":"101"}}
{ "update" : {"_index":"movies", "_id":"1"} }
{ "doc" : {"title" : "The Godfather (Original)"} }
```
