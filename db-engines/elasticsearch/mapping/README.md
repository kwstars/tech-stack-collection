## 数据类型

### `object` 类型

```json
DELETE emails

#  定义了一个名为 "emails" 的索引的结构。这个索引有三个字段："to"、"subject" 和 "attachments"。"attachments" 字段是一个对象，它有自己的字段："filename" 和 "filetype"。
PUT emails
{
  "mappings": {
    "properties": {
      "to": {
        "type": "text",
        "fields": {}
      },
      "subject": {
        "type": "text"
      },
      "attachments": {
        "properties": {
          "filename": {
            "type": "text",
            "fields": {
              "raw": {
                "type": "keyword"
              }
            }
          },
          "filetype": {
            "type": "text",
            "fields": {
              "raw": {
                "type": "keyword"
              }
            }
          }
        }
      }
    }
  }
}

# 在 "emails" 索引中添加一个新的文档。
PUT emails/_doc/1
{
  "to:": "johndoe@johndoe.com",
  "subject": "Testing Object Type",
  "attachments": {
    "filename": "file1.txt",
    "filetype": "confidential"
  }
}

# 在 "emails" 索引中搜索包含 "file1.txt" 附件的电子邮件。
GET emails/_search
{
  "query": {
    "term": {
      "attachments.filename.raw": "file1.txt"
    }
  }
}

# object 类型在 Elasticsearch 中的一个主要限制是，它不能正确处理数组中的多个对象，因为它无法保持数组中每个对象的独立性，导致在查询时可能无法得到预期的结果。
PUT emails/_doc/2
{
  "to:":"mrs.doe@johndoe.com",
  "subject":"Multi attachments test",
  "attachments":[{
    "filename":"file2.txt",
    "filetype":"confidential"
  },{
    "filename":"file3.txt",
    "filetype":"private"
  }]
}

# 这里搜索就会出现问题，因为 Elasticsearch 无法区分数组中的两个对象。
GET emails/_search
{
  "query": {
    "bool": {
      "must": [
        {"term": { "attachments.filename.raw": "file2.txt"}},
        {"term": { "attachments.filetype.raw": "private" }}
      ]
    }
  }
}
```

### `nested` 类型

`nested` 类型就是解决上面 `object` 类型的问题，`nested` 类型可以保持数组中每个对象的独立性，从而可以正确处理数组中的多个对象。

```json
PUT emails_nested
{
  "mappings": {
    "properties": {
      "attachments": {
        "type": "nested",
        "properties": {
          "filename": {
            "type": "keyword"
          },
          "filetype": {
            "type": "text"
          }
        }
      }
    }
  }
}

PUT emails_nested/_doc/1
{
  "attachments" : [
    {
      "filename" : "file1.txt",
      "filetype" :  "confidential"
    },
    {
      "filename" : "file2.txt",
      "filetype" :  "private"
    }
  ]
}

# 在 "emails_nested" 索引中搜索 "attachments" 字段中 "filename" 为 "file1.txt" 并且 "filetype" 为 "private" 的文档。
GET emails_nested/_search
{
  "query": {
    "nested": {
      "path": "attachments",
      "query": {
        "bool": {
          "must": [
            { "match": { "attachments.filename": "file1.txt" }},
            { "match": { "attachments.filetype":  "private" }}
          ]
        }
      }
    }
  }
}


# Nested Aggregation
POST emails_nested/_search
{
  "size": 0,           // 不返回任何文档，只返回聚合结果
  "aggs": {            // 聚合查询的开始
    "filenames": {        // 自定义的聚合名称
      "nested": {      // 使用 nested 聚合，因为 "actors" 字段是 nested 类型
        "path": "attachments"  // nested 字段的路径
      },
      "aggs": {           // 在 nested 聚合内部进行更多的聚合
        "step1": {    // 自定义的聚合名称
          "terms": {      // 使用 terms 聚合，找出出现次数最多的值
            "field": "attachments.filename",  // 要进行聚合的字段
            "size": 10    // 返回出现次数最多的前 10 个值
          }
        }
      }
    }
  }
}

# 普通 aggregation不工作
POST my_movies/_search
{
  "size": 0,
  "aggs": {
    "NAME": {
      "terms": {
        "field": "attachments.filename",
        "size": 10
      }
    }
  }
}
```

### `flattended` 类型

```json
PUT consultations
{
  "mappings": {
    "properties": {
      "patient_name":{
        "type": "text"
      },
      "doctor_notes":{
        "type": "flattened"
      }
    }
  }
}

PUT consultations/_doc/1
{
  "patient_name": "John Doe",
  "doctor_notes": {
    "temperature": 103,
    "symptoms": [
      "chills",
      "fever",
      "headache"
    ],
    "history": "none",
    "medication": [
      "Antibiotics",
      "Paracetamol"
    ]
  }
}

GET consultations/_search
{
  "query": {
    "match": {
      "doctor_notes": "Paracetamol"
    }
  }
}

# 搜索 doctor_notes 字段中包含 "headache" 和 "Antibiotics"，但不包含 "diabetics" 的文档。
GET consultations/_search
{
  "query": {
    "bool": {
      "must": [
        {"match": {"doctor_notes": "headache"}},
        {"match": {"doctor_notes": "Antibiotics"}}
      ],
      "must_not": [{"term": {"doctor_notes": {"value": "diabetics"}}}]
    }
  }
}

DELETE bug_reports
PUT bug_reports
{
  "mappings": {
    "properties": {
      "title": {
        "type": "text"
      },
      "labels": {
        "type": "flattened"
      }
    }
  }
}

POST bug_reports/_doc/1
{
  "title": "Results are not sorted correctly.",
  "labels": {
    "priority": "urgent",
    "release": ["v1.2.5", "v1.3.0"],
    "timestamp": {
      "created": 1541458026,
      "closed": 1541457010
    }
  }
}

POST bug_reports/_search
{
  "query": {
    "term": {"labels": "urgent"}
  }
}

POST bug_reports/_search
{
  "query": {
    "term": {"labels.release": "v1.3.0"}
  }
}
```

### `join` 类型

```json
# 定义了一个名为 doctors 的索引，doctor 和 patient 是父子关系，doctor 是父文档，patient 是子文档。
PUT doctors
{
  "mappings": {
    "properties": {
      "relationship":{
        "type": "join",
        "relations":{
          "doctor":"patient" # 'doctor' 和 'patient' 是父子关系，'doctor' 是父文档，'patient' 是子文档
        }
      }
    }
  }
}

# 在 'doctors' 索引中添加一个新的文档，文档的 ID 是 1。这个文档表示一个医生。
PUT doctors/_doc/1  # 使用 PUT 请求向 'doctors' 索引添加一个文档，文档的 ID 是 1
{
  "name":"Dr Mary Montgomery",  # 'name' 字段表示医生的名字
  "relationship":{
    "name":"doctor"  # 'relationship' 字段是一个对象，它的 'name' 属性表示这个文档的角色，在这里，角色是 'doctor'
  }
}

# 在 'doctors' 索引中添加一个新的文档，文档的 ID 是 2。这个文档是 'Dr Mary Montgomery' 的一个病人。
# routing=mary 是自定义的。这里的 mary 是一个任意选择的值，它的目的是确保所有与 'Dr Mary Montgomery' 相关的文档（包括 'Dr Mary Montgomery' 自己的文档和她的所有病人的文档）都被存储在同一个分片中。
PUT doctors/_doc/2?routing=mary
{
  "name":"John Doe",  # 'name' 字段表示病人的名字
  "relationship":{
    "name":"patient",  # 'relationship' 字段是一个对象，它的 'name' 属性表示这个文档的角色，在这里，角色是 'patient'
    "parent":1  # 'parent' 属性表示这个文档的父文档的 ID，这里是 1，表示这个病人的医生是 'Dr Mary Montgomery'
  }
}

# 在 'doctors' 索引中添加一个新的文档，文档的 ID 是 3。这个文档也是 'Dr Mary Montgomery' 的一个病人。
PUT doctors/_doc/3?routing=mary
{
  "name":"Mrs Doe",
  "relationship":{
    "name":"patient",
    "parent":1
  }
}

# 在 'doctors' 索引中搜索 'Dr Mary Montgomery' 的病人。
GET doctors/_search
{
  "query": {
    "parent_id":{
      "type":"patient",
      "id":1
    }
  }
}
```

> [!note]
> 在 Elasticsearch 中实现父子关系会对性能产生影响。如果你正在考虑文档关系，Elasticsearch 可能并不是合适的工具，所以请谨慎使用这个功能。

## 映射参数

### `dynamic` 参数

请注意，虽然 Dynamic Mapping 可以方便快速地创建索引，但在生产环境中，最佳实践通常是预先定义好映射，以便更精确地控制字段的类型和行为。

以下是以二维表的方式展示 Dynamic Mappings 的控制:

| 动作/设置      | "true" | "false" | "strict" |
| -------------- | ------ | ------- | -------- |
| 文档可被索引   | YES    | YES     | NO       |
| 字段可被索引   | YES    | NO      | NO       |
| Mapping 被更新 | YES    | NO      | NO       |

- 当 dynamic 被设置为 "false" 时，如果有新增字段的数据写入，该数据可以被索引，但新增字段会被丢弃。
- 当设置为 "strict" 模式时，数据写入会直接出错。

以下是设置 dynamic 为 "false" 的示例:

```bash
PUT movies
{
  "mappings": {
    "_doc": {
      "dynamic": "false"
    }
  }
}
```
