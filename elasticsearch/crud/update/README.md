## 更新文档

```json
DELETE movies

# 创建索引
PUT movies/_doc/1
{
  "title":"The Godfather",
  "synopsis":"The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son"
}

# 添加新的字段
POST movies/_update/1
{
  "doc": {
    "actors":["Marlon Brando","Al Pacino","James Caan"],
    "director":"Francis Ford Coppola"
  }
}

# 修改已经存在的文档
POST movies/_update/1
{
  "doc": {
    "title":"The Godfather (Original)"
  }
}

GET movies/_doc/1
```

## 脚本更新

```json
# 添加一个演员
POST movies/_update/1
{
  "script": {
    "source": "ctx._source.actors.add('Diane Keaton')"
  }
}

GET movies/_doc/1

# 删除一个演员
POST movies/_update/1
{
  "script": {
    "source": "ctx._source.actors.remove(ctx._source.actors.indexOf('Diane Keaton'))"
  }
}

# 添加一个新的字段
POST movies/_update/1
{
  "script": {
    "source": "ctx._source.imdb_user_rating = 9.2"
  }
}

# 删除一个字段
POST movies/_update/1
{
  "script": {
    "source": "ctx._source.remove('metacritic_rating')"
  }
}

# 添加多个字段
POST movies/_update/1
{
  "script": {
    "source": """
    ctx._source.runtime_in_minutes = 175;
    ctx._source.metacritic_rating= 100;
    ctx._source.tomatometer = 97;
    ctx._source.boxoffice_gross_in_millions = 134.8;
    """
  }
}

# 条件更新
POST movies/_update/1
{
  "script": {
    "source": """
    if(ctx._source.boxoffice_gross_in_millions > 125)
      {ctx._source.blockbuster = true}
     else
      {ctx._source.blockbuster = false}
    """
  }
}

# 通过参数传递
POST movies/_update/1
{
  "script": {
    "source": """
 if(ctx._source.boxoffice_gross_in_millions > params.gross_earnings_threshold)
   {ctx._source.blockbuster = true}
 else
   {ctx._source.blockbuster = false}
 """,
    "params": {
      "gross_earnings_threshold":150
    }
  }
}
```

## 替换文档

```json
PUT movies/_doc/1
{
  "title":"Avatar"
}
```

## Upserts

```json
# 如果文档不存在则插入
POST movies/_update/5
{
  "script": {
    "source": "ctx._source.gross_earnings = '357.1m'"
  },
  "upsert": {
    "title":"Top Gun",
    "gross_earnings":"357.5m"
  }
}

# `_update` 一个不存在的文档会报错
POST movies/_update/11
{
  "doc": {
    "runtime_in_minutes":110
  }
}

# 如果文档不存在则插入
POST movies/_update/11
{
  "doc": {
    "runtime_in_minutes":110
  },
  "doc_as_upsert":true
}
```

## 通过查询更新

```json
POST movies/_update_by_query
{
  "query": {
    "match": {
      "actors": "Al Pacino"
    }
  },

  "script": {
    "source": """
    ctx._source.actors.add('Oscar Winner Al Pacino');
    ctx._source.actors.remove(ctx._source.actors.indexOf('Al Pacino'))
    """,
    "lang": "painless"
  }
}
```
