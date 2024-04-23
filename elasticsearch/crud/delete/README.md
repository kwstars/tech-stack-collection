## 指定 ID 删除文档

```json
### Deleting a document given an ID
DELETE movies/_doc/1
```

## 查询删除

```json
PUT movies/_doc/101
{
  "title":"Jaws",
  "director":"Steven Spielberg",
  "gross_earnings_in_millions":355
}

PUT movies/_doc/102
{
  "title":"Jaws II",
  "director":"Steven Spielberg",
  "gross_earnings_in_millions":375
}

PUT movies/_doc/103
{
  "title":"Jaws III",
  "director":"Steven Spielberg",
  "gross_earnings_in_millions":300
}

# 查询删除
POST movies/_delete_by_query
{
  "query": {
    "match": {
      "director": "James Cameron"
    }
  }
}

POST movies/_delete_by_query
{
  "query": {
    "range": {
      "gross_earnings_in_millions": {
        "gt": 350,
        "lt": 400
      }
    }
  }
}

# 不存在
GET movies/_doc/101

# 不存在
GET movies/_doc/102

# 存在
GET movies/_doc/103
```

```json
## Complex delete query
POST movies/_delete_by_query
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "director": "Steven Spielberg"
          }
        }
      ],
      "must_not": [
        {
          "range": {
            "imdb_rating": {
              "gte": 9,
              "lte": 9.5
            }
          }
        }
      ],
      "filter": [
        {
          "range": {
            "gross_earnings_in_millions": {
              "lt": 100
            }
          }
        }
      ]
    }
  }
}
```

## 删除所有文档

```json
POST movies/_delete_by_query
{
  "query": {
    "match_all": {}
  }
}

# 删除多个索引的文档
POST <index_1>,<index_2>,<index_3>/_delete_by_query
{
  "query": {
    "match_all": {}
  }
}
```
