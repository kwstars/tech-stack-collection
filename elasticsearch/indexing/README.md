## 创建

```json
# 隐式创建索引（自动创建）
PUT cars/_doc/1
{
  "make":"Maserati",
  "model":"GranTurismo Sport",
  "speed_mph":186
}

# 默认情况下，如果索引不存在，Elasticsearch 会自动创建所需的索引。如果想要限制这个功能，需要将 action.auto_create_index 设置为 false。
# PUT _cluster/settings
# {
#  "persistent": {
#    "action.auto_create_index":false
#  }
# }

# 创建索引的时候定义 mapping 和 settings
PUT cars_index_with_sample_mapping
{
  "mappings": {
    "properties": {
      "make": {
        "type": "text"
      }
    }
  },
  "settings": {
    "number_of_shards": 3,
    "number_of_replicas": 5,
    "codec": "best_compression",
    "max_script_fields": 128,
    "refresh_interval": "60s"
  }
}

# 创建一个名为 'cars_for_aliases' 的索引，并定义别名 'my_new_cars_alias'
PUT cars_for_aliases
{
  "aliases": {
    "my_new_cars_alias": {}
  }
}
PUT cars_for_aliases/_alias/my_cars_alias

# 分别创建了三个名为cars1、cars2和cars3的索引，并为这三个索引创建了一个名为multi_cars_alias的别名。
PUT cars1
PUT cars2
PUT cars3
PUT cars1,cars2,cars3/_alias/multi_cars_alias

# 创建带有通配符的别名
PUT cars*/_alias/wildcard_cars_alias
```

## 读取

```json
# 获取索引的配置（mapping，aliases，settings）
GET _all
GET *
GET cars
GET mov*,stu*
GET ca*

# 获取指标的对应的配置
GET cars/_settings
GET cars/_mapping
GET cars/_alias

# 获取索引的设置
GET cars_with_custom_settings/_settings

# 获取多个索引的设置
GET cars1,cars2,cars3/_settings
GET cars*/_settings

# 获取索引的单个属性
GET cars_with_custom_settings/_settings/index.number_of_shards
```

## 更新

```json
# 更新索引的动态属性
# setting: 分为静态配置和动态配置。静态配置是在索引创建时应用且在索引运行期间无法更改的设置，如分片数、压缩编码等，而动态配置可以在索引运行时应用和更改，如副本数、刷新间隔等。https://www.elastic.co/guide/en/elasticsearch/reference/current/index-modules.html#index-modules-settings
PUT cars_with_custom_settings/_settings
{
  "settings": {
    "number_of_replicas": 2
  }
}
```

## 删除

```json
# 删除多个索引
DELETE cars,movies,order

# 删除别名
DELETE cars/_alias/cars_alias
```

## 管理

```json
# 获取索引的统计信息
GET cars/_stats

# 获取多个索引的统计信息
GET cars*/_stats

# 获取集群中所有索引的统计信息
GET */_stats

# 展示了如何返回段中的统计信息
GET cars/_stats/segments

# 将所有使用 "vintage_cars_alias" 别名的操作从 "vintage_cars" 索引重定向到 "vintage_cars_new" 索引。
PUT vintage_cars
PUT vintage_cars_new
POST _aliases
{
  "actions": [
    {
      "remove": {
        "index": "vintage_cars",
        "alias": "vintage_cars_alias"
      }
    },
    {
      "add": {
        "index": "vintage_cars_new",
        "alias": "vintage_cars_alias"
      }
    }
  ]
}

# 创建指向多个索引的别名
PUT power_cars
PUT rare_cars
PUT luxury_cars
POST _aliases
{
  "actions": [
    {
      "add": {
        "indices": ["vintage_cars","power_cars","rare_cars","luxury_cars"],
        "alias": "high_end_cars_alais"
      }
    }
  ]
}
```

### 打开和关闭

```json
# 关闭 cars 索引。释放与该索引相关的所有内存资源，但磁盘上的数据仍然保持不变，当重新打开索引时，数据将再次变得可用。
POST cars/_close?wait_for_active_shards=index-setting

# 关闭多个索引
POST cars1,*mov*,students*/_close?wait_for_active_shards=index-setting

# 防止 `_all` 或 `*` 的操作
PUT _cluster/settings
{
  "persistent": {
    "action.destructive_requires_name":true
  }
}

# 以防止任何索引被误关闭。
PUT _cluster/settings
{
  "persistent": {
    "cluster.indices.close.enable":false
  }
}

# 开启 `cars` 索引。
POST cars/_open
```

### 拆分索引（Splitting an index）

```json
PUT all_cars/_settings
{
  "settings":{
    "index.blocks.write":"true"
  }
}

POST all_cars/_split/all_cars_new
{
  "settings": {
    "index.number_of_shards": 12
  }
}
```

拆分索引的操作有一些注意事项：

1. **目标索引在操作前必须不存在**：在拆分过程中，在请求对象中提供的配置会被复制到目标索引，源索引的精确副本会被传输到目标索引。
2. **目标索引的分片数必须是源索引分片数的倍数**：如果源索引有三个主分片，那么目标索引可以定义为三的倍数（如三、六、九等）的分片数量。
3. **目标索引永远不能比源索引的主分片少**：记住，拆分是为了给索引提供更多的空间。
4. **目标索引的节点必须有足够的空间**：确保分片被分配了适当的空间。

### 缩小索引（Shrinking an index）

```json
PUT all_cars/_settings
{
  "settings": {
    "index.blocks.write": true,
    "index.routing.allocation.require._name": "node1"
  }
}

PUT all_cars/_shrink/all_cars_new2
{
  "settings":{
    "index.blocks.write":null,
    "index.routing.allocation.require._name":null,
    "index.number_of_shards":1,
    "index.number_of_replicas":5
  }
}
```

缩小索引的操作有一些注意事项：

1. **源索引必须关闭索引写入**：源索引必须切换为只读。虽然不是强制性的，但建议在缩小之前也关闭副本。
2. **目标索引在缩小操作之前不能存在**：在执行缩小操作之前，目标索引不能被创建或存在。
3. **所有索引分片必须位于同一节点**：必须在索引上设置 `index.routing.allocation.require.<node_name>` 属性，并指定节点名称来实现这一点。
4. **目标索引的分片数必须是源索引分片数的因子**：例如，如果的 `all_cars` 索引有 50 个分片，那么只能缩小到 25、10、5 或 2 个分片。
5. **目标索引的节点必须满足内存要求**：在执行缩小操作时，必须确保目标索引的节点有足够的内存来存储缩小后的索引。

### 滚动索引别名（Rolling over an index alias）

```json
PUT cars_2021-000001

POST _aliases
{
  "actions": [
    {
      "add": {
        "index": "cars_2021-000001",
        "alias": "latest_cars_a",
        "is_write_index": true
      }
    }
  ]
}

POST latest_cars_a/_rollover
# 返回如下结果
#{
#  "acknowledged" : true,
#  "shards_acknowledged" : true,
#  "old_index" : "latest_cars-000001", # 旧索引的名字
#  "new_index" : "latest_cars-000002", # 新索引的名字
#  "rolled_over" : true,
#  "dry_run" : false,
#  "conditions" : { }
#}
```

调用别名上的 `_rollover` 命令会做几件事：

- 创建一个新的索引（`cars_2021-000002`），配置与旧的索引相同（名称前缀保持不变，但破折号后的后缀递增）。
- 将别名重新映射以指向新生成的新索引（在这种情况下，为 `cars_2021-000002`）。的查询不受影响，因为所有查询都是针对别名（而不是物理索引）编写的。
- 删除当前索引上的别名，并将其重新指向新创建的滚动索引。

## [索引模板（Index templates）](https://www.elastic.co/guide/en/elasticsearch/reference/current/index-templates.html)

索引模板（Index templates）是 Elasticsearch 中用于复制相同设置到多个索引的功能，可以避免重复和错误的设置。可以预先定义一个包含模式的索引模板，当新的索引名称匹配到模板时，新的索引将会根据这个模板来创建。

索引模板的一个使用场景是基于环境创建一组模式，例如，开发环境的索引可能有 3 个分片和 2 个副本，而生产环境的索引可能有 10 个分片和每个分片有 5 个副本。可以在模板中包含一组映射、设置和别名，以及一个索引名称。当创建一个新的索引时，如果索引名称匹配到模式名称，模板就会被应用。可以基于全局命令模式（如通配符、前缀等）创建模板。

从 7.8 版本开始，Elasticsearch 升级了其模板功能，新的版本更加抽象和可重用。有两种类型的模板：索引模板（Index templates）和组件模板（Component templates）。

![Composable (index) templates are composed of component templates](https://image.linux88.com/2024/04/23/d26fb928f5ced097ddaeb4ae11e5f48b.svg)

组件模板是可复用的构建块，用于配置映射（mappings）、设置（settings）和别名（aliases）。虽然可以使用组件模板来构造索引模板，但它们并不直接应用于一组索引。索引模板可以包含一组组件模板，也可以直接指定设置、映射和别名。

```json
POST _component_template/dev_settings_component_template
{
  "template": {
    "settings": {
      "number_of_shards": 3,
      "number_of_replicas": 3
    }
  }
}

POST _component_template/dev_mapping_component_template
{
  "template": {
    "mappings": {
      "properties": {
        "created_by": {
          "type": "text"
        },
        "version": {
          "type": "float"
        }
      }
    }
  }
}

POST _index_template/composed_cars_template
{
  "index_patterns": [
    "*cars*"
  ],
  "priority": 200,
  "composed_of": [
    "dev_settings_component_template",
    "dev_mapping_component_template"
  ]
}
```

首先，创建了两个组件模板，一个名为 dev_settings_component_template，用于设置分片和副本的数量，另一个名为 dev_mapping_component_template，用于定义字段的映射。然后，创建了一个索引模板 composed_cars_template，它由上述两个组件模板组成，并应用于所有名称包含 "cars" 的索引。

## [索引的生命周期](https://www.elastic.co/guide/en/elasticsearch/reference/current/index-lifecycle-management.html)

一个索引有五个生命周期阶段：热（hot）、温（warm）、冷（cold）、冻结（frozen）和删除（delete）。下面简要描述每个阶段：

- **热（Hot）**：索引处于全面操作模式。它可用于读取和写入，从而使索引既可以进行索引操作，也可以进行查询。
- **温（Warm）**：索引处于只读模式。索引操作被关闭，但索引对查询开放，因此可以服务于搜索和聚合查询。
- **冷（Cold）**：索引处于只读模式。与温阶段类似，索引操作被关闭，但索引对查询开放，尽管预期查询会较少。当索引处于此阶段时，搜索查询可能会导致响应时间变慢。
- **冻结（Frozen）**：与冷阶段类似，索引操作被关闭，但允许查询。然而，查询更少见甚至很少见。当索引处于此阶段时，用户可能会注意到查询响应时间较长。
- **删除（Delete）**：这是索引的最后阶段，它被永久删除。因此，数据被擦除，资源被释放。通常在删除索引之前会对其进行快照，以便将来可以从快照中恢复数据。

创建和应用 ILM 策略

### 手动管理索引生命周期

```json
# 步骤1: 创建 ILM 策略
PUT _ilm/policy/hot_delete_policy
{
  "policy": {
    "phases": {
      "hot": { // 热阶段
        "min_age": "1d", // 索引预计至少存在一天才执行操作
        "actions": {
          "set_priority": {  // 设置优先级
            "priority": 250  // 在节点恢复期间，优先级较高的索引将被优先考虑
          }
        }
      },
      "delete": {  // 删除阶段
        "actions": {
          "delete" : { }  // 一旦热阶段完成所有操作，索引就会被删除
        }
      }
    }
  }
}

# 步骤2: 创建索引并将 ILM 策略附加到索引
PUT hot_delete_policy_index
{
  "settings": {
    "index.lifecycle.name":"hot_delete_policy"
  }
}
```

### Lifecycle with rollover

```json
# 创建一个 IML 策略
PUT _ilm/policy/hot_simple_policy
{
  "policy": {
    "phases": {
      "hot": {
        "min_age": "0ms",
        "actions": {
          "rollover": {
            "max_age": "1d",
            "max_docs": 10000,
            "max_size": "10gb"
          }
        }
      }
    }
  }
}

# 将 ILM 策略附加到索引模板
PUT _index_template/mysql_logs_template
{
  "index_patterns": ["mysql-*"],
  "template":{
    "settings":{
      "index.lifecycle.name":"hot_simple_policy",
      "index.lifecycle.rollover_alias":"mysql-logs-alias"
    }
  }
}

# 创建一个索引并将其设置为可写
PUT mysql-index-000001
{
  "aliases": {
    "mysql-logs-alias": {
      "is_write_index":true
    }
  }
}

# 创建一个高级生命周期策略
PUT _ilm/policy/hot_warm_delete_policy
{
  "policy": {
    "phases": {
      "hot": {  // 热阶段
        "min_age": "1d",  // 索引预计至少存在一天才执行操作
        "actions": {
          "rollover": {  // 滚动操作
            "max_size": "40gb",  // 当索引大小达到40GB时，执行滚动操作
            "max_age": "6d"  // 当索引存在6天时，执行滚动操作
          },
          "set_priority": {  // 设置优先级
            "priority": 50  // 在节点恢复期间，优先级较高的索引将被优先考虑
          }
        }
      },
      "warm": {  // 温阶段
        "min_age": "7d",  // 索引预计至少存在7天才进入温阶段
        "actions": {
          "shrink": {  // 收缩操作
            "number_of_shards": 1  // 将索引的分片数量减少到1
          }
        }
      },
      "delete": {  // 删除阶段
        "min_age": "30d",  // 索引预计至少存在30天才进入删除阶段
        "actions": {
          "delete": {}  // 执行删除操作
        }
      }
    }
  }
}
```



## 参考

- https://www.elastic.co/guide/en/elasticsearch/reference/current/aliases.html
- https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-open-close.html
- https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-close.html
