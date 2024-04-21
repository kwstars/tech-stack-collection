## 0. prepare

```json
DELETE movies

PUT movies
{
  "mappings": {
    "properties": {
      "title": {
        "type": "text",
        "fields": {
          "original": {
            "type": "keyword"
          }
        }
      },
      "synopsis": {
        "type": "text",
        "fields": {
          "original": {
            "type": "keyword"
          }
        }
      },
      "actors": {
        "type": "text",
        "fields": {
          "original": {
            "type": "keyword"
          }
        }
      },
      "director": {
        "type": "text",
        "fields": {
          "original": {
            "type": "keyword"
          }
        }
      },
      "rating": {
        "type": "half_float"
      },
      "release_date": {
        "type": "date",
        "format": "dd-MM-yyyy"
      },
      "certificate": {
        "type": "keyword",
        "fields": {
          "original": {
            "type": "keyword"
          }
        }
      },
      "genre": {
        "type": "text",
        "index_prefixes":{},
        "fields": {
          "original": {
            "type": "keyword"
          }
        }
      }
    }
  }
}

POST _bulk
{"index":{"_index":"movies","_id":"1"}}
{"title": "The Shawshank Redemption","synopsis": "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.","actors": ["Tim Robbins", "Morgan Freeman", "Bob Gunton", "William Sadler"] ,"director":" Frank Darabont ","rating":9.3,"certificate":"R","genre": "Drama ","release_date":"17-02-1995"}
{"index":{"_index":"movies","_id":"2"}}
{"title": "The Godfather","synopsis": "An organized crime dynasty's aging patriarch transfers control of his clandestine empire to his reluctant son.","actors": ["Marlon Brando", "Al Pacino", "James Caan", "Diane Keaton"] ,"director":" Francis Ford Coppola ","rating":9.2,"certificate":"R","genre": ["Crime", "Drama"] ,"release_date":"14-03-1972"}
{"index":{"_index":"movies","_id":"3"}}
{"title": "The Dark Knight","synopsis": "When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.","actors": ["Christian Bale", "Heath Ledger", "Aaron Eckhart", "Michael Caine"] ,"director":" Christopher Nolan ","rating":9.0,"certificate":"PG-13","genre": ["Action", "Crime", "Drama"] ,"release_date":"18-07-2008"}
{"index":{"_index":"movies","_id":"4"}}
{"title": "The Godfather: Part II","synopsis": "The early life and career of Vito Corleone in 1920s New York City is portrayed, while his son, Michael, expands and tightens his grip on the family crime syndicate.","actors": ["Al Pacino", "Robert De Niro", "Robert Duvall", "Diane Keaton"] ,"director":" Francis Ford Coppola ","rating":9.0,"certificate":"R","genre": ["Crime", "Drama"] ,"release_date":"20-12-1974"}
{"index":{"_index":"movies","_id":"5"}}
{"title": "12 Angry Men","synopsis": "A jury holdout attempts to prevent a miscarriage of justice by forcing his colleagues to reconsider the evidence.","actors": ["Henry Fonda", "Lee J. Cobb", "Martin Balsam", " John Fiedler"] ,"director":" Sidney Lumet ","rating":9.0,"certificate":"Approved","genre": ["Crime", "Drama"],"release_date":"10-04-1957" }
{"index":{"_index":"movies","_id":"6"}}
{"title": "The Lord of the Rings: The Return of the King","synopsis": "Gandalf and Aragorn lead the World of Men against Saurons's army to draw his gaze from Frodo and Sam as they approach Mount Doom with the One Ring.","actors": ["Elijah Wood", "Viggo Mortensen", "Ian McKellen", "Orlando Bloom"] ,"director":" Peter Jackson ","rating":8.9,"certificate":"PG-13","genre": ["Action", "Adventure", "Drama"] ,"release_date":"06-02-2004"}
{"index":{"_index":"movies","_id":"7"}}
{"title": "Pulp Fiction","synopsis": "The lives of two mob hitmen, a boxer, a gangster and his wife, and a pair of diner bandits intertwine in four tales of violence and redemption.","actors": ["John Travolta", "Uma Thurman", "Samuel L. Jackson", "Bruce Willis"] ,"director":" Quentin Tarantino ","rating":8.9,"certificate":"R","genre": ["Crime", "Drama"] ,"release_date":"14-10-1994"}
{"index":{"_index":"movies","_id":"8"}}
{"title": "Schindler's List","synopsis": "In German-occupied Poland during World War II, industrialist Oskar Schindler gradually becomes concerned for his Jewish workforce after witnessing their persecution by the Nazis.","actors": ["Liam Neeson", "Ralph Fiennes", "Ben Kingsley", "Caroline Goodall"] ,"director":" Steven Spielberg ","rating":8.9,"certificate":"R","genre": ["Biography", "Drama", "History"] ,"release_date":"04-07-1994"}
{"index":{"_index":"movies","_id":"9"}}
{"title": "Inception","synopsis": "A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.","actors": ["Leonardo DiCaprio", "Joseph Gordon-Levitt", "Elliot Page", "Ken Watanabe"] ,"director":" Christopher Nolan ","rating":8.8,"certificate":"PG-13","genre": ["Action", "Adventure", "Sci-Fi"] ,"release_date":"16-07-2010"}
{"index":{"_index":"movies","_id":"10"}}
{"title": "Fight Club","synopsis": "An insomniac office worker and a devil-may-care soap maker form an underground fight club that evolves into much more.","actors": ["Brad Pitt", "Edward Norton", "Meat Loaf", "Zach Grenier"] ,"director":" David Fincher ","rating":8.8,"certificate":"R","genre": "Drama","release_date":"11-11-1999"}
{"index":{"_index":"movies","_id":"11"}}
{"title": "The Lord of the Rings: The Fellowship of the Ring","synopsis": "A meek Hobbit from the Shire and eight companions set out on a journey to destroy the powerful One Ring and save Middle-earth from the Dark Lord Sauron.","actors": ["Elijah Wood", "Ian McKellen", "Orlando Bloom", "Sean Bean"] ,"director":" Peter Jackson ","rating":8.8,"certificate":"PG-13","genre": ["Action", "Adventure", "Drama"] ,"release_date":"15-03-2002"}
{"index":{"_index":"movies","_id":"12"}}
{"title": "Forrest Gump","synopsis": "The presidencies of Kennedy and Johnson, the Vietnam War, the Watergate scandal and other historical events unfold from the perspective of an Alabama man with an IQ of 75, whose only desire is to be reunited with his childhood sweetheart.","actors": ["Tom Hanks", "Robin Wright", "Gary Sinise", "Sally Field"] ,"director":" Robert Zemeckis ","rating":8.8,"certificate":"PG-13","genre": ["Drama", "Romance"] ,"release_date":"06-07-1994"}
{"index":{"_index":"movies","_id":"13"}}
{"title": "The Good, the Bad and the Ugly","synopsis": "A bounty hunting scam joins two men in an uneasy alliance against a third in a race to find a fortune in gold buried in a remote cemetery.","actors": ["Clint Eastwood", "Eli Wallach", "Lee Van Cleef", "Aldo GiuffrÃ¨"] ,"director":" Sergio Leone ","rating":8.8,"certificate":"R","genre": "Western","release_date":"23-12-1966"}
{"index":{"_index":"movies","_id":"14"}}
{"title": "The Lord of the Rings: The Two Towers","synopsis": "While Frodo and Sam edge closer to Mordor with the help of the shifty Gollum, the divided fellowship makes a stand against Sauron's new ally, Saruman, and his hordes of Isengard.","actors": ["Elijah Wood", "Ian McKellen", "Viggo Mortensen", "Orlando Bloom"] ,"director":" Peter Jackson ","rating":8.7,"certificate":"PG-13","genre": ["Action", "Adventure", "Drama"],"release_date":"28-03-2003"}
{"index":{"_index":"movies","_id":"15"}}
{"title": "The Matrix","synopsis": "When a beautiful stranger leads computer hacker Neo to a forbidding underworld, he discovers the shocking truth--the life he knows is the elaborate deception of an evil cyber-intelligence.","actors": ["Keanu Reeves", "Laurence Fishburne", "Carrie-Anne Moss", "Hugo Weaving"] ,"director":["Lana Wachowski", "Lilly Wachowski"] ,"rating":8.7,"certificate":"R","genre": ["Action", "Sci-Fi"] ,"release_date":"16-05-2003"}
{"index":{"_index":"movies","_id":"16"}}
{"title": "Goodfellas","synopsis": "The story of Henry Hill and his life in the mob, covering his relationship with his wife Karen Hill and his mob partners Jimmy Conway and Tommy DeVito in the Italian-American crime syndicate.","actors": ["Robert De Niro", "Ray Liotta", "Joe Pesci", "Lorraine Bracco"] ,"director":" Martin Scorsese ","rating":8.7,"certificate":"R","genre": ["Biography", "Drama", "Crime"],"release_date":"19-09-1990" }
{"index":{"_index":"movies","_id":"17"}}
{"title": "Star Wars: Episode V - The Empire Strikes Back","synopsis": "After the Rebels are brutally overpowered by the Empire on the ice planet Hoth, Luke Skywalker begins Jedi training with Yoda, while his friends are pursued across the galaxy by Darth Vader and bounty hunter Boba Fett.","actors": ["Mark Hamill", "Harrison Ford", "Carrie Fisher", "Billy Dee Williams"] ,"director":" Irvin Kershner ","rating":8.7,"certificate":"PG-13","genre": ["Action", "Adventure", "Fantasy"] ,"release_date":"21-05-1980"}
{"index":{"_index":"movies","_id":"18"}}
{"title": "One Flew Over the Cuckoo's Nest","synopsis": "A criminal pleads insanity and is admitted to a mental institution, where he rebels against the oppressive nurse and rallies up the scared patients.","actors": ["Jack Nicholson", "Louise Fletcher", "Michael Berryman", "Peter Brocco"] ,"director":" Milos Forman ","rating":8.7,"certificate":"R","genre": "Drama" ,"release_date":"19-11-1975"}
{"index":{"_index":"movies","_id":"19"}}
{"title": "Parasite","synopsis": "Greed and class discrimination threaten the newly formed symbiotic relationship between the wealthy Park family and the destitute Kim clan.","actors": ["Kang-ho Song", "Sun-kyun Lee", "Yeo-jeong Cho", "Woo-sik Choi"] ,"director":" Bong Joon Ho ","rating":8.6,"certificate":"R","genre": ["Comedy", "Drama", "Thriller"] ,"release_date":"30-05-2019"}
{"index":{"_index":"movies","_id":"20"}}
{"title": "Interstellar","synopsis": "A team of explorers travel through a wormhole in space in an attempt to ensure humanity's survival.","actors": ["Matthew McConaughey", "Anne Hathaway", "Jessica Chastain", "Mackenzie Foy"] ,"director":" Christopher Nolan ","rating":8.6,"certificate":"PG-13","genre": ["Adventure", "Drama", "Sci-Fi"] ,"release_date":"07-11-2014"}
{"index":{"_index":"movies","_id":"21"}}
{"title": "City of God","synopsis": "In the slums of Rio, two kids paths diverge as one struggles to become a photographer and the other a kingpin.","actors": ["Alexandre Rodrigues", "Leandro Firmino", "Matheus Nachtergaele", "Phellipe Haagensen"] ,"director": ["Fernando Meirelles", "KÃ¡tia Lund"] ,"rating":8.6,"certificate":"R","genre": ["Crime", "Drama"],"release_date":"30-08-2002" }
{"index":{"_index":"movies","_id":"22"}}
{"title": "Spirited Away","synopsis": "During her family's move to the suburbs, a sullen 10-year-old girl wanders into a world ruled by gods, witches, and spirits, and where humans are changed into beasts.","actors": ["Daveigh Chase", "Suzanne Pleshette", "Miyu Irino", "Rumi Hiiragi"] ,"director":" Hayao Miyazaki ","rating":8.6,"certificate":"PG-13","genre": ["Animation", "Adventure", "Family"],"release_date":"20-07-2001"}
{"index":{"_index":"movies","_id":"23"}}
{"title": "Saving Private Ryan","synopsis": "Following the Normandy Landings, a group of U.S. soldiers go behind enemy lines to retrieve a paratrooper whose brothers have been killed in action.","actors": ["Tom Hanks", "Matt Damon", "Tom Sizemore", "Edward Burns"] ,"director":" Steven Spielberg ","rating":8.6,"certificate":"R","genre": ["Drama", "War"] ,"release_date":"21-07-1998"}
{"index":{"_index":"movies","_id":"24"}}
{"title": "The Green Mile","synopsis": "The lives of guards on Death Row are affected by one of their charges: a black man accused of child murder and rape, yet who has a mysterious gift.","actors": ["Tom Hanks", "Michael Clarke Duncan", "David Morse", "Bonnie Hunt"] ,"director":" Frank Darabont ","rating":8.6,"certificate":"R","genre": ["Crime", "Drama", "Fantasy"] ,"release_date":"06-12-1999"}
{"index":{"_index":"movies","_id":"25"}}
{"title": "Life Is Beautiful","synopsis": "When an open-minded Jewish librarian and his son become victims of the Holocaust, he uses a perfect mixture of will, humor, and imagination to protect his son from the dangers around their camp.","actors": ["Roberto Benigni", "Nicoletta Braschi", "Giorgio Cantarini", "Giustino Durano"] ,"director":" Roberto Benigni ","rating":8.6,"certificate":"PG-13","genre": ["Comedy", "Drama", "Romance"],"release_date":"14-09-2012"}
```

## 1. `term` query

```json
# 在 "certificate" 字段中查找值为 "R" 的文档
GET movies/_search
{
  "query": {
    "term": {
      "certificate": "R"
    }
  }
}

# 在 "certificate" 字段中查找值为 "r" 的文档
# 没有数据返回
GET movies/_search
{
  "query": {
    "term": {
      "certificate": "r"
    }
  }
}

# 这个 term 查询不会返回预期的结果
# 因为 "title" 字段可能已经被分析，"The Godfather" 可能被分为 "The" 和 "Godfather"
# term 查询是精确匹配，所以它会在 "title" 字段中查找完全匹配 "The Godfather" 的文档，而不是包含 "The" 或 "Godfather" 的文档
GET movies/_search
{
  "query": {
    "term": {
      "title": "The Godfather"
    }
  }
}
```

总结：

1. 大小写敏感：对于 `keyword` 字段，`term` 查询是大小写敏感的。如果想进行大小写不敏感的查询，需要在索引文档时将字段设置为小写。
2. 精确匹配：`term` 查询用于查找在特定字段中包含特定 term 的文档。它不会对查询 term 进行分析，所以它适用于精确匹配。

## 2. `terms` query

```json
# 在 "certificate" 字段中查找值为 "PG-13" 或 "R" 的文档
GET movies/_search
{
  "query": {
    "terms": {
      "certificate": ["PG-13","R"]
    }
  }
}

# 默认情况下 `term` 查询限制为最多 65,536 个 terms。可以使用 index.max_terms_count 设置更改此限制。
PUT movies/_settings
{
  "index":{
    "max_terms_count":10
  }
}
```

```json
DELETE classic_movies

PUT classic_movies
{
  "mappings": {
    "properties": {
      "title": {
        "type": "text"
      },
      "director": {
        "type": "keyword"
      }
    }
  }
}

PUT classic_movies/_doc/1
{
  "title":"Jaws",
  "director":"Steven Spielberg"
}

PUT classic_movies/_doc/2
{
  "title":"Jaws II",
  "director":"Jeannot Szwarc"
}

PUT classic_movies/_doc/3
{
  "title":"Ready Player One",
  "director":"Steven Spielberg"
}

# 这是一个 terms 查询，它使用了一个特殊的形式，称为 "terms lookup"
# 它会在 "classic_movies" 索引中查找 "director" 字段匹配从另一个文档获取的值的文档
# 这个查询会从 "classic_movies" 索引中的 ID 为 3 的文档获取 "director" 字段的值
# 然后，它会在 "director" 字段中查找匹配这个值的文档
GET classic_movies/_search
{
  "query": {
    "terms": {
      "director": {
        "index":"classic_movies",
        "id":"3",
        "path":"director"
      }
    }
  }
}
```

## 3. `ids` query

```json
# 这是一个 ids 查询
# 它会在 "movies" 索引中查找 ID 为 10、4、6 或 8 的文档
GET movies/_search
{
  "query": {
    "ids": {
      "values": [10,4,6,8]
    }
  }
}

# 这是一个 terms 查询
# 它也会在 "movies" 索引中查找 ID 为 10、4、6 或 8 的文档
GET movies/_search
{
  "query": {
    "terms": {
    "_id":[10,4,6,8]
    }
  }
}
```

## 4. `exists` query

```json
# 它会在 "movies" 索引中查找 "_id" 字段存在的文档
GET movies/_search
{
  "query": {
    "exists": {
      "field": "_id"
    }
  }
}

# 它会在 "movies" 索引中查找 "title" 字段存在的文档
GET movies/_search
{
  "query": {
    "exists": {
      "field": "title"
    }
  }
}

PUT top_secret_files/_doc/1
{
  "code":"Flying Bird",
  "confidential":true
}

PUT top_secret_files/_doc/2
{
  "code":"Cold Rock"
}

# 这是一个 bool 查询，它使用了 must_not 条件
# 它会在 "top_secret_files" 索引中查找 "confidential" 字段不存在的文档
GET top_secret_files/_search
{
  "query": {
    "bool": {
      "must_not": [
        {
          "exists": {
            "field": "confidential"
          }
        }
      ]
    }
  }
}
```

## 5. `range` query

```json
# 这是一个 range 查询
# 它会在 "movies" 索引中查找 "rating" 字段的值在 9.0 到 9.5（包含）之间的文档
GET movies/_search
{
  "query": {
    "range": {
      "rating": {
        "gte": 9.0,  # gte 表示 "大于或等于"
        "lte": 9.5   # lte 表示 "小于或等于"
      }
    }
  }
}

# 这是一个 range 查询，配合了排序操作
# 它会在 "movies" 索引中查找 "release_date" 字段的值在 1970 年 1 月 1 日之后的文档
# 然后，它会按照 "release_date" 字段的值的升序（asc）对这些文档进行排序
GET movies/_search
{
  "query": {
    "range": {
      "release_date": {
        "gte": "01-01-1970"  # gte 表示 "大于或等于"
      }
    }
  },
  "sort": [
    {
      "release_date": {
        "order": "asc"  # asc 表示 "升序"
      }
    }
  ]
}

# 这是一个使用日期数学的 range 查询
# 它会在 "movies" 索引中查找 "release_date" 字段的值在 1995 年 2 月 15 日之前两天（即 1995 年 2 月 13 日）的文档
GET movies/_search
{
  "query": {
    "range": {
      "release_date": {
        "lte": "15-02-1995||-2d"  # lte 表示 "小于或等于"，"-2d" 表示 "减去两天"
      }
    }
  }
}

# 这是一个使用日期数学的 range 查询
# 它会在 "movies" 索引中查找 "release_date" 字段的值在 2019 年 3 月 1 日之前两天（即 2019 年 2 月 27 日）之后的文档
GET movies/_search
{
  "query": {
    "range": {
      "release_date": {
        "gte": "01-03-2019||-2d"  # gte 表示 "大于或等于"，"-2d" 表示 "减去两天"
      }
    }
  }
}

# 这是一个使用日期数学的 range 查询
# 它会在 "movies" 索引中查找 "release_date" 字段的值在 2022 年 3 月 17 日之前两天（即 2022 年 3 月 15 日）的文档
GET movies/_search
{
  "query": {
    "range": {
      "release_date": {
        "lte": "17-03-2022||-2d"  # lte 表示 "小于或等于"，"-2d" 表示 "减去两天"
      }
    }
  }
}

# 这是一个使用日期数学的 range 查询
# 它会在 "movies" 索引中查找 "release_date" 字段的值在当前时间的前四年（即最近四年）的文档
GET movies/_search
{
  "query": {
    "range": {
      "release_date": {
        "gte": "now-4y"  # gte 表示 "大于或等于"，"now-4y" 表示 "当前时间减去四年"
      }
    }
  }
}

# 这是一个使用日期数学的 range 查询
# 它会在 "movies" 索引中查找 "release_date" 字段的值在当前时间的前四年（即最近四年）到现在这段时间内的文档
GET movies/_search
{
  "query": {
    "range": {
      "release_date": {
        "gte": "now-4y",  # gte 表示 "大于或等于"，"now-4y" 表示 "当前时间减去四年"
        "lte": "now"  # lte 表示 "小于或等于"，"now" 表示 "当前时间"
      }
    }
  }
}
```

## 6. `wildcard` query

```json
# 这是一个带有末尾通配符的 wildcard 查询
# 它会在 "movies" 索引中查找 "title" 字段的值以 "god" 开头的文档
GET movies/_search
{
  "query": {
    "wildcard": {
      "title": {
        "value": "god*"  # "*" 是一个通配符，表示任意字符的序列
      }
    }
  }
}

# 这是一个带有中间通配符的 wildcard 查询
# 它会在 "movies" 索引中查找 "title" 字段的值中包含 "g" 和 "d"，并且 "g" 在 "d" 之前的文档
GET movies/_search
{
  "_source": false,  # 这个选项表示只返回匹配的文档的 ID，不返回其他字段的值
  "query": {
    "wildcard": {
      "title": {
        "value": "g*d"  # "*" 是一个通配符，表示任意字符的序列
      }
    }
  },
  "highlight": {  # 这个选项表示高亮显示匹配的字段
    "fields": {
      "title": {}  # 这里表示高亮显示 "title" 字段
    }
  }
}

# 这是一个带有末尾通配符的 wildcard 查询
# 它会在 "movies" 索引中查找 "title.original" 字段的值以 "The God" 开头的文档
GET movies/_search
{
  "query": {
    "wildcard": {
      "title.original": {
        "value": "The God*"  # "*" 是一个通配符，表示任意字符的序列
      }
    }
  },
  "highlight": {  # 这个选项表示高亮显示匹配的字段
    "fields": {
      "title": {}  # 这里表示高亮显示 "title" 字段
    }
  }
}

# 临时禁用昂贵的查询 https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl.html#query-dsl-allow-expensive-queries
PUT _cluster/settings
{
  "transient": {  # "transient" 表示这个设置是临时的，会在集群重启后失效
    "search.allow_expensive_queries": "false"  # "false" 表示禁止执行昂贵的查询
  }
}
```

## 7. `prefix` query

```json
# 这是一个前缀查询
# 它会在 "movies" 索引中查找 "genre.original" 字段的值以 "Ad" 开头的文档
GET movies/_search
{
  "query": {
    "prefix": {
      "genre.original": {
        "value": "Ad"  # "Ad" 是要匹配的前缀
      }
    }
  },
  "highlight": {  # 这个选项表示高亮显示匹配的字段
    "fields": {
      "genre.original": {}  # 这里表示高亮显示 "genre.original" 字段
    }
  }
}

# 搜索以 "Mar" 为前缀的演员
# 这是一个前缀查询
# 它会在 "movies" 索引中查找 "actors.original" 字段的值以 "Mar" 开头的文档
GET movies/_search
{
  "_source": false,  # 这个选项表示只返回匹配的文档的 ID，不返回其他字段的值
  "query": {
    "prefix": {
      "actors.original": {
        "value": "Mar"  # "Mar" 是要匹配的前缀
      }
    }
  },
  "highlight": {  # 这个选项表示高亮显示匹配的字段
    "fields": {
      "actors.original": {}  # 这里表示高亮显示 "actors.original" 字段
    }
  }
}

# 创建一个名为 "boxoffice_hit_movies" 的索引
# 并在 "title" 字段上启用前缀索引
PUT boxoffice_hit_movies
{
  "mappings": {
    "properties": {
      "title":{
        "type": "text",
        "index_prefixes":{}  # 启用前缀索引
      }
    }
  }
}

# 在 "boxoffice_hit_movies" 索引中添加一个文档
# 文档的 ID 是 1，"title" 字段的值是 "Gladiator"
PUT boxoffice_hit_movies/_doc/1
{
  "title":"Gladiator"
}

# 在 "boxoffice_hit_movies" 索引中执行一个前缀查询
# 查找 "title" 字段的值以 "gla" 开头的文档
GET boxoffice_hit_movies/_search
{
  "query": {
    "prefix": {
      "title": {
        "value": "gla"  # "gla" 是要匹配的前缀
      }
    }
  }
}

# 创建一个名为 "boxoffice_hit_movies_custom_prefix_sizes" 的索引
# 并在 "title" 字段上启用自定义大小的前缀索引
PUT boxoffice_hit_movies_custom_prefix_sizes
{
  "mappings": {
    "properties": {
      "title":{
        "type": "text",
        "index_prefixes":{
          "min_chars":4,  # 前缀索引的最小字符数
          "max_chars":10  # 前缀索引的最大字符数
        }
      }
    }
  }
}
```

## 8. `fuzzy` query

```json
# 执行一个模糊查询，编辑距离为 1
# 这个查询会在 "movies" 索引中查找 "genre" 字段的值与 "rama" 的编辑距离为 1 的文档
GET movies/_search
{
  "query": {
    "fuzzy": {
      "genre": {
        "value": "rama",  # "rama" 是要匹配的值
        "fuzziness": 1  # "fuzziness" 是编辑距离，表示可以接受的字符变化的最大数量
      }
    }
  },
  "highlight": {  # 这个选项表示高亮显示匹配的字段
    "fields": {
      "genre": {}  # 这里表示高亮显示 "genre" 字段
    }
  }
}

# 执行一个模糊查询，编辑距离为 1
# 这个查询会在 "movies" 索引中查找 "genre" 字段的值与 "drma" 的编辑距离为 1 的文档
GET movies/_search
{
  "query": {
    "fuzzy": {
      "genre": {
        "value": "drma",  # "drma" 是要匹配的值
        "fuzziness": 1  # "fuzziness" 是编辑距离，表示可以接受的字符变化的最大数量
      }
    }
  }
}

# 执行一个模糊查询，编辑距离为 2
# 这个查询会在 "movies" 索引中查找 "genre" 字段的值与 "ama" 的编辑距离为 2 的文档
GET movies/_search
{
  "query": {
    "fuzzy": {
      "genre": {
        "value": "ama",  # "ama" 是要匹配的值
        "fuzziness": 2  # "fuzziness" 是编辑距离，表示可以接受的字符变化的最大数量
      }
    }
  }
}
```

## 9. `regexp` query

## 10. `terms_set` query

## 总结

Term-level 查询的主要特点和类型包括：

1. Term-level 查询主要在结构化数据上进行，如数字、关键字、布尔值和日期。
2. Term-level 查询只会产生两个结果：要么找到或要么找不到。没有可能匹配的情况。
3. Term-level 查询不会被分析，这意味着当它们应用于在索引过程中进行文本分析的文本字段时，可能会产生错误的结果或没有结果。
4. 有许多 term-level 查询，包括：term、terms、prefix、range、fuzzy 等。
5. term 查询在一个字段上搜索一个单一的 term，而 terms（复数）查询在一个字段上搜索多个值。
6. range 查询帮助在一定范围内搜索数据，例如，搜索过去一个月在伦敦发生的犯罪。
7. wildcard 查询使用 `*` 和 `?` 操作符来获取结果。
8. Fuzziness 使用 Levenshtein 的编辑距离来获取相似的单词。Elasticsearch 使用 fuzzy 查询来支持用户的拼写不一致。
9. prefix 查询根据给定的前缀检索结果（无需指定 wildcard 操作符）。由于在实时索引上执行前缀操作的代价很高，可以要求 Elasticsearch 在索引时预先创建它们，以避免在实时查询阶段找到它们。
