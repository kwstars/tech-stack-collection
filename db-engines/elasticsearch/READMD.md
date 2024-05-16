## 基本概念

| Elasticsearch  |  MySQL   |
| :------------: | :------: |
|     Index      | Database |
| Type（已废弃） |  Table   |
|    Document    |   Row    |
|     Filed      |  Column  |
|    Mapping     |  Schema  |
|      DSL       |   SQL    |

- **Index（索引）**: 在 Elasticsearch 中，索引是一种存储和组织数据的方式，类似于关系数据库中的 "数据库"。一个索引包含一系列具有相似结构的文档。
- **Type（类型）**: 在 Elasticsearch 7.0 及以上版本中，"Type" 的概念已被废弃。为了兼容旧版本的代码，Elasticsearch 引入了 "`_doc`" 作为默认的类型名称。"`_doc`" 可以被视为一个占位符，它不再具有任何实际意义，但在 API 路径中仍然需要出现。
- **Document（文档）**: 在 Elasticsearch 中，文档是可以被索引的基本信息单位，类似于关系数据库中的 "行"。一个文档是一个包含一些字段和值的 JSON 对象。
- **Field（字段）**: 字段是文档中的一个具体的数据点，类似于关系数据库中的 "列"。每个字段都有一个名称和一个或多个值。字段的类型决定了字段的存储和搜索方式，例如，它可以是文本、日期、数字等类型。
- **Mapping（映射）**: 映射是定义如何存储和索引文档及其字段的过程，类似于关系数据库中的 "表结构定义"。映射描述了字段的类型、分词器、格式等信息。
- **DSL（Domain Specific Language）**: 即领域特定语言。Elasticsearch 提供了一种基于 JSON 的 DSL 来定义查询。这种 DSL 使得可以以一种简洁和灵活的方式来构建复杂的查询，包括全文检索、过滤、排序、聚合等操作。

![img](https://api.contentstack.io/v2/uploads/5820f4627decd7211255ff54/download?uid=bltc8f954a4ac72be22)

- **Cluster（集群）**: Elasticsearch 中的集群是由一个或多个节点组成的，它们共同持有全部数据，并提供联合的索引和搜索功能。
- **[Node（节点）](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-node.html)**: 节点是集群中的一个服务器，用于存储数据、参与集群的索引和搜索功能等。在 Elasticsearch 中，有多种类型的节点，每种类型的节点都有不同的角色和功能:

  - **Master Node（主节点）**: 负责集群级别的管理和控制，例如创建或删除索引，跟踪哪些节点是集群的一部分，以及决定如何将分片分配给各个节点。

  - **Data Node（数据节点）**: 存储数据并执行与数据相关的操作，如搜索和聚合。

  - **Data Content Node**: 存储用户的文档数据，执行搜索和聚合等数据相关操作。

  - **Data Hot Node**: 存储索引的最新数据，通常配置有更高的硬件资源以处理大量的写入操作。

  - **Data Warm Node**: 存储索引的较旧数据，通常用于较少的写入和更多的读取操作。

  - **Data Cold Node**: 存储索引的更旧数据，这些数据被访问的频率较低。

  - **Data Frozen Node**: 存储最旧的数据，这些数据被访问的频率非常低，可能需要一些时间来从深度存储中检索。

  - **Ingest Node**: 预处理文档，例如执行提取、转换和加载 (ETL) 任务，然后将文档传递给数据节点。

  - **Machine Learning Node（机器学习节点）**: 执行机器学习任务，需要安装 X-Pack 插件。

  - **Remote Cluster Client Node**: 用于处理跨集群搜索和跨集群复制。

  - **Transform Node**: 用于执行转换任务，将现有的 Elasticsearch 索引转换为新的摘要索引。

- **Shard（分片）**: 为了能够在多个节点上分配和并行处理数据，Elasticsearch 将索引分割成多个片段，这些片段就是分片。

  - **Segments（段）**: 一个分片会进一步被划分为多个段。每个段都是一个倒排索引，存储实际的数据。段是不可变的（immutable）。这些相同大小的段在固定时间后被合并（Merged）成一个更大的段，以实现高效的搜索。这整个过程对用户来说是完全透明的，并由 Elasticsearch 自动处理。

- **Replica（副本）**: 为了提高数据的可用性和系统的容错能力，Elasticsearch 会创建分片的一份或多份复制品，这些复制品就是副本。

### 倒排索引（Inverted Index）

倒排索引是一种用于文本搜索的数据结构，其核心组成包括以下部分:

- **Term Dictionary（单词词典）**: 记录所有文档的单词，以及单词到倒排列表的关联关系。单词词典一般比较大，可以通过 B+树或哈希拉链法实现，以满足高性能的插入与查询。

- **Posting List（倒排列表）**: 记录了单词对应的文档集合，由倒排索引项组成。

  - **Posting（倒排索引项）**: 每个倒排索引项包含以下信息:
    - **文档 ID**: 标识了包含该单词的文档。
    - **词频 TF**: 该单词在文档中出现的次数，用于相关性评分。
    - **位置 Position**: 单词在文档中分词的位置，用于语句搜索（phrase query）。
    - **偏移 Offset**: 记录单词的开始结束位置，实现高亮显示。

当进行搜索查询时，Elasticsearch 会首先在单词词典中查找每个查询词，然后获取对应的倒排列表，通过倒排列表找到包含所有查询词的文档，最后根据词频、文档长度等因素计算每个文档的相关性得分，返回得分最高的文档。

倒排索引的结构可以简单地表示如下:

```
Term Dictionary
----------------
| Term 1 | -----> | Posting List |
| Term 2 | -----> | Posting List |
| Term 3 | -----> | Posting List |
|  ...   |        |     ...      |
----------------

Posting List
----------------
| Doc ID | TF | Position | Offset |
| Doc ID | TF | Position | Offset |
|  ...   | .. |   ...    |  ...   |
----------------
```

在 Elasticsearch 中，每个字段默认都会被索引，也就是说，每个字段都有自己的倒排索引。这使得可以对任何字段进行搜索。

然而，对于某些知道不需要搜索的字段，可以选择不对它们进行索引，以节省存储空间。这可以通过在映射中为这些字段设置 `"index": false` 来实现。

这样做的优点是可以节省存储空间，因为倒排索引占用的空间可以相当大。但缺点是，这些字段将无法被搜索。也就是说，不能在搜索查询中使用这些字段。此外，这些字段也不能用于排序和聚合。

### [相关度（Relevancy）](https://www.elastic.co/guide/en/elasticsearch/reference/current/index-modules-similarity.html#_available_similarities)

"相关度"（Relevancy）是现代搜索引擎的一个重要概念。它不仅基于查询条件返回结果，而且还会分析并返回最相关的结果。这是通过一种称为 "相关度评分"（Relevance Scoring）的过程实现的，该过程会根据各种因素（如查询词在文档中出现的频率、查询词在整个文档集中出现的频率等）为每个结果分配一个分数。

例如，如果你是一名开发人员或 DevOps 工程师，你可能已经使用过 Stack Overflow 来搜索技术问题的答案。在 Stack Overflow 上搜索很少会让人失望（至少在大多数情况下）。你对一个查询得到的结果通常都非常接近你正在寻找的内容。结果按照一定的顺序排序，从最相关的结果开始，到最不相关的结果结束。如果一个查询的结果不能满足你的需求，那么你可能不会再次使用 Stack Overflow。但是，如果结果杂乱无章，你可能就不会再回来了。

"相关度评分"（Relevancy Scores）是搜索引擎如 Elasticsearch 在返回搜索结果时，对结果进行排序的一种机制。相关度评分是一个正浮点数，用于确定搜索结果的排名。Elasticsearch 默认使用 Best Match 25（BM25）相关度算法对返回结果进行评分，以便客户端可以获得相关的结果。BM25 是先前使用的词频/逆文档频率（TF/IDF）相似性算法的高级版本。

例如，如果在书名中搜索 "Java"，那么标题中包含 "Java" 一词多次的文档比标题中只出现一次或不出现的文档更相关。在计算相关度评分时，Elasticsearch 使用字段长度规范算法：第一个标题中的搜索词（"Effective Java"，包含两个词）比第二个标题中的搜索词（"Head First Java"，包含三个词）更相关。

相关度评分是根据所使用的相似性算法生成的。在这个例子中，Elasticsearch 默认应用了 BM25 算法来确定评分。这个算法依赖于词频、逆文档频率和字段长度，但 Elasticsearch 提供了更多的灵活性：它除了 BM25 外还提供了一些其他的算法。这些算法被打包在一个名为 "similarity" 的模块中，用于对匹配的文档进行排名。

## [Mapping](https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping.html)

1. **文档和字段**：每个文档由具有值的字段组成，每个字段都有一个数据类型。Elasticsearch 提供了丰富的数据类型来表示这些值。
2. **映射规则**：有动态（dynamic mapping）或显式（explicit mapping）映射。
3. **映射机制**：映射是一种预先创建字段模式定义的机制。Elasticsearch 在索引文档时会参考这些模式定义，以便数据被分析和存储，以便更快地检索。
4. **动态映射（dynamic mapping）**：虽然动态映射很方便，特别是在开发中，但如果我们对数据模型了解得更多，最好是预先创建映射（explicit mapping）。
5. **数据类型**：Elasticsearch 提供了广泛的数据类型，包括文本、布尔值、数值、日期等，甚至还有复杂的字段，如 joins、completion、geopoints、nested 等。

### 多字段（multi-fields）

单 field 索引

```json
PUT /my-index-000001
{
  "mappings": {
    "properties": {
      "age":    { "type": "integer" },
      "email":  { "type": "keyword"  },
      "name":   { "type": "text"  }
    }
  }
}
```

多 field 索引

```json
PUT my-index-000001
{
  "mappings": {
    "properties": {
      "city": {
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
```

在 Elasticsearch 的映射中，`type` 和 `fields` 有着不同的含义和用途。

- `type`：这是字段的数据类型。这意味着 Elasticsearch 会根据这些类型来**解析和存储**这些字段的数据。

- `fields`：这是一个可选的参数，用于定义多字段。多字段允许在同一字段上定义多种数据类型。这意味着，可以既对 `city` 进行全文本搜索，也可以对 `city.raw` 进行精确值搜索。

总的来说，`type` 定义了字段的主要数据类型，而 `fields` 允许在同一字段上定义多种数据类型，**以满足不同的搜索需求**。

### [元数据字段](https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-fields.html#mapping-fields)

### [字段数据类型](https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html)

Elasticsearch 的数据类型大致可以分为精确值（exact values）和全文本（full text）。

- **精确值（Exact values）**: 这些类型的字段用于存储确切的值，如数字、日期、布尔值或关键字。这些字段通常用于过滤（例如，查找年龄等于 30 的所有用户）、排序（例如，按日期排序）或聚合（例如，计算平均年龄）。关键字字段是一种特殊类型的字符串字段，它存储数据的确切值，不进行任何分析或令牌化。

  - `binary`: 接受一个作为 Base64 编码字符串的二进制值。默认情况下，该字段不会被存储，也不可搜索。例如，`binary` 类型可以用于存储和检索非文本信息，如图片、音频或任何其他二进制数据。
  - `boolean`: 接受 `true` 和 `false` 两个值。这种类型的字段非常适合用于存储布尔值。例如，`boolean` 类型可以用于存储和搜索二元状态，如用户的激活状态（激活或未激活）、博客文章的发布状态（已发布或未发布）等。
  - Keywords
    - `keyword` 类型用于存储结构化内容，如 ID、电子邮件地址、主机名、状态码、邮政编码或标签，这些字段存储数据的确切值，不进行任何分析或令牌化。
    - `constant_keyword`: 是 keyword 字段的一种特化，用于所有索引中的文档都具有相同值的情况。例如，constant_keyword 类型可以用于存储和搜索在所有文档中都相同的数据，如产品的版本号、数据集的来源等。
    - `wildcard`: wildcard 类型是一种专门用于非结构化机器生成内容的关键字字段，优化了具有大值或高基数的字段。例如，`wildcard` 类型可以用于存储和搜索日志文件，其中可能包含大量的非结构化数据，如错误消息、堆栈跟踪等，这些数据可以使用类似 grep 的通配符和正则表达式查询进行搜索。
  - Numbers
    - 对于整数类型应该选择足够满足用例的最小类型。这将帮助索引和搜索更加高效。
      - `long`: 有符号 64 位整数，最小值为$-2^{63}$，最大值为 $2^{63}-1$。
      - `integer`: 有符号 32 位整数，最小值为$-2^{31}$，最大值为 $2^{31}-1$。
      - `short`: 有符号 16 位整数，最小值为-32，768，最大值为 32，767。
      - `byte`: 有符号 8 位整数，最小值为-128，最大值为 127。
      - `unsigned_long`: 无符号 64 位整数，最小值为 0，最大值为 $2^{64}-1$。
    - 在选择浮点数类型时，如果`scaled_float`适合的用例，那么通常更有效，因为它使用缩放因子将浮点数据存储到整数中，这有助于节省磁盘空间。如果`scaled_float`不适合，那么应该在`double`，`float`和`half_float`中选择足够满足用例的最小类型。选择的依据应该是的精度需求和存储空间考虑。
      - `double`: 双精度 64 位 IEEE 754 浮点数，限制为有限值。
      - `float`: 单精度 32 位 IEEE 754 浮点数，限制为有限值。
      - `half_float`: 半精度 16 位 IEEE 754 浮点数，限制为有限值。
      - `scaled_float`: 由长整数支持的浮点数，通过固定的双精度缩放因子进行缩放。
  - Dates
    - `date`: 日期字段用于存储日期和时间信息。日期字段可以包含日期、时间或日期和时间的组合。日期字段可以存储日期和时间信息，如“2015-01-01”、“2015-01-01T12:10:30”或“2015-01-01T12:10:30+01:00”。
    - `date_nanos`: 日期字段的变体，精确到纳秒。
  - `alias`: alias 类型是一种特殊的关键字字段，用于将一个或多个字段的值合并到一个字段中。
  - `object`: 这是默认的类型，用于存储 JSON 对象。它将 JSON 对象的每个字段都存储为单独的字段。但是，`object` 类型无法正确处理数组中的多个对象，因为它无法保持数组中每个对象的独立性。
  - `nested`: 用于存储数组中的 JSON 对象，它可以保持数组中每个对象的独立性。这意味着，当你查询 `nested` 类型的字段时，Elasticsearch 会正确地处理每个对象。但是，使用 `nested` 类型会增加存储和查询的复杂性。
  - `flattended`: 用于存储复杂的 JSON 对象，但不需要对对象的每个字段进行单独的查询。`flattened` 类型将整个 JSON 对象存储为一个字段，这可以节省存储空间，并提高查询性能。但是，你无法对 `flattened` 类型的字段进行精确的查询。
  - `join`: 用于存储父子关系的数据。它允许你在一个索引中存储和查询父子关系的数据。但是，使用 `join` 类型会增加存储和查询的复杂性，并且它有一些限制，例如，你不能在具有 `join` 字段的索引中使用 `_source` 字段。
  - Range

    - `integer_range`: 有符号 32 位整数范围，最小值为$-2^{31}$，最大值为 $2^{31}-1$。
    - `float_range`: 单精度 32 位 IEEE 754 浮点数范围，限制为有限值。
    - `long_range`: 有符号 64 位整数范围，最小值为$-2^{63}$，最大值为 $2^{63}-1$。
    - `double_range`: 双精度 64 位 IEEE 754 浮点数范围，限制为有限值。
    - `date_range`: 日期范围字段用于存储日期和时间信息。日期范围字段可以包含日期、时间或日期和时间的组合。日期范围字段可以存储日期和时间信息，如“2015-01-01”、“2015-01-01T12:10:30”或“2015-01-01T12:10:30+01:00”。
    - `ip_range`: IPv4 或 IPv6 地址范围，可以指定一个或多个 IP 地址范围。例如，ip_range 类型可以用于存储和搜索 IP 地址范围，如允许访问的 IP 地址范围。

  - `ip`: IPv4 或 IPv6 地址，可以指定一个或多个 IP 地址。例如，ip 类型可以用于存储和搜索 IP 地址，如用户的 IP 地址、服务器的 IP 地址等。
  - `version`: version 类型是一种特殊的整数字段，用于存储文档的版本号。每次更新文档时，版本号都会递增。这使得可以检测到文档的冲突和并发更新。
  - `murmur3`: Murmur3 哈希值，用于存储和搜索哈希值。例如，murmur3 类型可以用于存储和搜索哈希值，如密码哈希、文件哈希等。
  - `aggregate_metric`: aggregate_metric 类型是一种特殊的数字字段，用于存储和搜索聚合度量。例如，aggregate_metric 类型可以用于存储和搜索聚合度量，如平均值、总和、最小值、最大值等。
  - `histogram`: histogram 类型是一种特殊的数字字段，用于存储和搜索直方图数据。例如，histogram 类型可以用于存储和搜索直方图数据，如用户的年龄分布、产品的价格分布等。

- **全文本（Full text）**: 这些类型的字段用于存储全文本数据，如博客文章、电子邮件或产品描述。这些字段在存储数据时会进行分析，将文本分解成单独的、可搜索的项（通常是单词）。这使得可以搜索文本中的单个词或短语。
  - `text`: 用于全文本搜索的字段类型。它会对输入的文本进行分析，以便进行全文本搜索。例如，可以使用 `text` 字段来存储博客文章的内容，然后对文章进行全文本搜索。
  - `match_only_text`: 类似于 `text`，但只支持 `match` 和 `match_phrase` 查询。这可以防止执行可能导致混淆的查询，例如 `term` 查询。例如，可以使用 `match_only_text` 字段来存储用户评论，然后只允许对评论进行 `match` 或 `match_phrase` 查询。
  - `annotated-text`: 用于存储包含特殊标记的文本，通常用于识别命名实体。例如，可以使用 `annotated-text` 字段来存储新闻文章，并在文章中标记出人名、地名等实体。
  - `completion`: 用于自动完成建议的字段类型。它可以快速生成基于输入的建议。例如，可以使用 `completion` 字段来存储产品名称，然后根据用户的输入快速生成产品名称的建议。
  - `search_as_you_type`: 类似于 `text`，但专为即时完成搜索优化。它创建了多个子字段，以便在用户输入时提供更精确的建议。例如，可以使用 `search_as_you_type` 字段来存储电影标题，然后在用户输入时提供即时的电影标题建议。
  - `token_count`: 用于计算文本中的令牌数量的字段类型。它可以用于过滤或排序基于令牌数量的查询。例如，可以使用 `token_count` 字段来存储博客文章的内容，然后根据文章的长度（即令牌数量）进行过滤或排序。

多字段是一种常用的索引同一字段的不同方式的方法。例如，一个字符串字段可以作为文本字段进行全文搜索，也可以作为关键字字段进行排序或聚合。或者，可以使用标准分析器、英语分析器和法语分析器索引一个文本字段。

### [映射参数](https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-params.html)

- `analyzer`: 定义了 Elasticsearch 如何解析和处理字段中的文本数据。
- `coerce`: 控制 Elasticsearch 是否应尝试将错误的数据类型转换为字段的正确数据类型。
- `copy_to`: 允许将字段的值复制到另一个字段，这对于在多个字段上执行搜索或聚合非常有用。
- `doc_values`: 决定是否在磁盘上为字段创建列式存储，这对于排序和聚合操作非常有用。
- `dynamic`: 控制 Elasticsearch 如何处理新的未知字段，可以设置为 `true`（自动添加新字段），`false`（忽略新字段）或 `strict`（如果遇到新字段则抛出异常）。
- `eager_global_ordinals`: 决定是否预先加载全局序数，这可以提高某些类型的查询性能，但会增加内存使用。
- `enabled`: 控制是否应索引和搜索字段，如果设置为 `false`，则字段的内容不会被索引，因此不能被搜索。
- `fielddata`: 控制是否在文本字段上启用 fielddata，以便进行排序和聚合。默认情况下，文本字段上的 fielddata 是禁用的，因为它会消耗大量内存。
- `fields`: 允许为单个字段定义多个索引。这对于需要以多种方式处理单个字段的情况非常有用，例如，一个字符串字段可以作为全文本字段进行搜索，也可以作为关键字字段进行排序或聚合。
- `format`: 定义日期字段的格式，使 Elasticsearch 能够正确解析和格式化日期数据。
- `ignore_above`: 对于关键字和文本字段，可以设置此参数以忽略某个长度以上的值。这对于限制字段长度非常有用。
- `ignore_malformed`: 控制 Elasticsearch 是否应忽略格式错误的字段。如果设置为 `true`，格式错误的字段将被忽略，而不是导致错误。
- `index_options`: ==控制为字段索引哪些信息。这对于优化字段的索引大小和搜索性能非常有用==。
- `index_phrases`: 如果设置为 `true`，则会为两个或更多词的短语创建额外的索引。这可以提高短语查询的性能，但会增加索引大小。
- `index_prefixes`: 允许为字段的前缀创建额外的索引，以提高前缀查询的性能。
- `index`: 控制字段是否应被索引。如果设置为 `false`，字段的值不会被索引，因此不能被搜索。
- `meta`: 允许存储元数据，这些元数据不会被索引或搜索，但可以在获取文档时返回。
- `normalizer`: 定义了如何对关键字字段进行规范化，以便进行排序和聚合。
- `norms`: 决定是否应存储字段长度的规范化因子，这对于某些全文搜索功能非常重要，如评分。
- `null_value`: 允许为字段定义一个替代的值，该值将在字段的值为 `null` 时使用。
- `position_increment_gap`: 定义了在同一字段中的多个值之间的位置增量，这对于防止跨字段值的短语搜索非常有用。
- `properties`: 定义了对象字段的子字段。
- `search_analyzer`: 定义了在搜索时如何解析字段的值。
- `similarity`: 定义了用于评分文档的相似性算法。
- `subobjects`: 允许定义嵌套的对象字段，这对于存储和查询结构化数据非常有用。
- `store`: 决定是否应在磁盘上为字段存储单独的值，这对于某些类型的查询非常有用，但会增加磁盘使用。
- `term_vector`: 决定是否应存储字段的词项向量，这对于某些类型的全文搜索功能非常有用，如快速高亮或更复杂的文本分析。

## [文本分析（Text analysis）](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis.html)

在 Elasticsearch 中，文本分析的过程主要由以下三个步骤组成:

![An example of text analysis in action](https://image.linux88.com/2024/04/21/f2f57146b7574b508e4e111a7fd376db.svg)

1. **[字符过滤器（Character Filters）](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-charfilters.html)**: 这一步在字符级别上应用。文本中的每个字符都会经过这些过滤器。过滤器的任务是从文本字符串中删除不需要的字符。例如，这个过程可以清除 HTML 标签，如 `<h1>`、`<href>` 和 `<src>`。它还可以帮助替换文本（例如，将希腊字母替换为等效的英文单词）或匹配正则表达式中的文本并替换为其等效项（例如，基于正则表达式匹配电子邮件并提取组织的域）。字符过滤器是可选的；分词器可以在没有字符过滤器的情况下存在。Elasticsearch 提供了三种内置的字符过滤器: `html_strip`、`mapping` 和 `pattern_replace`。

2. **[分词器（Tokenizers）](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-tokenizers.html)**: 使用分隔符（如空格、标点或单词边界）将文本字段分割成单词。每个分词器必须有且只有一个分词器。Elasticsearch 提供了一些分词器，以帮助将输入文本分割成单个令牌，然后通过令牌过滤器进行进一步的规范化。Elasticsearch 默认使用标准分词器；它根据语法和标点符号分割单词。

3. **[标记过滤器（Token Filters）](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-tokenfilters.html)**: 对分词器产生的令牌进行进一步处理。例如，令牌过滤器可以更改大小写、创建同义词、提供词根（词干）、生成 n-grams 和 shingles 等。令牌过滤器是可选的。一个分词器模块可以有零个、一个或多个令牌过滤器。Elasticsearch 提供了一长串的内置令牌过滤器。

这个过程是顺序进行的，首先应用字符过滤器，然后是分词器，最后是令牌过滤器。这三个步骤共同构成了 Elasticsearch 的文本分词过程。

### 内置分词器（analyzer）

- [标准分词器（Standard Analyzer）](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-standard-analyzer.html): 主要工作是将输入文本分割成单词，并将这些单词转换为小写。
- [简单分词器（Simple Analyzer）](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-simple-analyzer.html#analysis-simple-analyzer): 会在遇到任何非字母字符时将文本分割成词元，比如数字、空格、连字符和撇号，并且会丢弃非字母字符，并将大写字母转换为小写字母。
- [空格分词器（Whitespace Analyzer）](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-whitespace-analyzer.html): 空格分词器指的是搜索引擎或文本处理系统中的一种分词器，它根据空白字符（例如空格或制表符）将文本分词。
- [停止词分词器（Stop Analyzer）](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-stop-analyzer.html): 与简单分词器类似，但会删除常见的停用词（例如“a”、“the”、“is”等）。
- [关键字分词器（Keyword Analyzer）](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-keyword-analyzer.html): 是一个不会对输入文本进行任何分析的分词器，它会将整个输入文本作为一个词元。
- [模式分词器（pattern analyzer）](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-pattern-analyzer.html): 模式分词器是一个基于正则表达式的分词器，它可以根据正则表达式将输入文本分割成词元（term）。
- [语言分词器（Language Analyzers）](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-lang-analyzer.html): Elasticsearch 提供了一系列针对不同语言的分词器，例如英语、法语、德语、意大利语、日语、荷兰语、葡萄牙语、俄语、西班牙语、土耳其语等。
- [指纹分词器（Fingerprint Analyzer）](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-fingerprint-analyzer.html): 指纹分词器是一种特殊的分词器，它会将输入文本转换为一个小写的、无空格的、无标点符号的字符串，以便进行精确的匹配。

### 中文分词器

对于中文分词，Elasticsearch 提供了几种内置的分词器，但最常用的可能是 `ik_max_word` 和 `ik_smart`，它们都来自于 IK Analysis 插件。

1. **ik_max_word**: 这个分词器会尽可能多地切分文本。例如，对于文本 "中华人民共和国"，它会切分为 "中华"、"中华人民"、"中华人民共和国"、"华人"、"人民"、"人民共和国"、"共和"、"共和国"、"和国" 等词语。

2. **ik_smart**: 这个分词器会尽可能少地切分文本。例如，对于文本 "中华人民共和国"，它只会切分为 "中华人民共和国"。

IK 分词器还支持自定义词库，并支持热更新分词字典。可以在这里找到更多关于 IK Analysis 插件的信息: [IK Analysis for Elasticsearch](https://github.com/medcl/elasticsearch-analysis-ik)。

另外，还有一种来自清华大学自然语言处理和社会人文计算实验室的中文分词器，叫做 THULAC（THU Lexical Analyzer for Chinese）。可以在这里找到更多关于 THULAC 的信息: [THULAC for Elasticsearch](https://github.com/microbun/elasticsearch-thulac-plugin)。

这些分词器都可以很好地处理中文文本，可以根据具体需求选择使用哪一个。例如，如果希望搜索结果更精确，可能会选择 `ik_smart` 或 `THULAC`；如果希望搜索结果更全面，可能会选择 `ik_max_word`。

### 自定义分词器

## 索引操作（Indexing operations）

- Elasticsearch 提供了索引 API 用于创建、读取、删除和更新索引。
- 每个索引有三组配置：别名、设置和映射。
- 索引可以隐式或显式创建：
  - 当索引不存在且首次为文档建立索引时，会触发隐式创建。隐式创建的索引会应用默认配置（如一个副本和一个分片）。
  - 当使用索引 API 以自定义配置集实例化索引时，会发生显式创建。
- 索引模板允许创建具有预定配置设置的索引，这些设置基于匹配的名称在索引创建期间应用。
- 可以使用收缩或分割机制调整索引的大小。收缩减少了分片的数量，而分割增加了更多的主分片。
- 根据需要，可以有条件地滚动索引。
- 索引生命周期管理 (ILM) 帮助在这些生命周期阶段之间转换索引：热、温、冷、冻结和删除。在热阶段，索引完全运行并开放搜索和索引；但在温和冷阶段，索引是只读的。

## 文档操作

## [Query DSL](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl.html)

Elasticsearch、Lucene 和 REST APIs 之间的关系:

1. **Lucene**: Lucene 是一个开源的全文搜索引擎库，它提供了高级的全文搜索功能和数据索引结构。Lucene 是 Elasticsearch 的核心，Elasticsearch 基于 Lucene 构建。

2. **Elasticsearch**: Elasticsearch 是一个基于 Lucene 的开源搜索引擎。它在 Lucene 的基础上提供了分布式搜索、API、实时分析等功能。Elasticsearch 使用 Lucene 作为其底层搜索库，提供了更高级的功能和更易用的 API。

3. **REST APIs**: Elasticsearch 提供了一组 RESTful API，允许用户执行各种操作，如索引和搜索数据、管理集群等。这些 API 是 Elasticsearch 的一部分，它们使得用户可以通过 HTTP 请求与 Elasticsearch 交互，无需直接使用 Java 或其他语言编写代码。

总的来说，Lucene 是 Elasticsearch 的底层搜索库，而 Elasticsearch 的 REST APIs 则是用户与 Elasticsearch 交互的接口。

### [Term-level search](https://www.elastic.co/guide/en/elasticsearch/reference/current/term-level-queries.html)

Term-level queries 主要用于精确值匹配。这种查询类型通常用于过滤操作，例如查找特定值的字段，或者查找在特定范围内的值。

Term-level queries 不会对查询字符串进行分析。这意味着它们会按照提供的确切形式来匹配字段的值。例如，如果在一个已经分析和索引的文本字段上执行术语查询，查询将尝试找到与提供的确切术语匹配的文档，而不是尝试理解和分析查询字符串的含义。

以下是一些常见的术语级别查询:

1. **`exists` query**: 返回包含字段的任何索引值的文档。
2. **`fuzzy` query**: 返回包含与搜索词相似的词的文档。Elasticsearch 使用 Levenshtein 编辑距离来衡量相似性或模糊性。
3. **`ids` query**: 根据文档 ID 返回文档。
4. **`prefix` query**: 返回包含提供字段中特定前缀的文档。
5. **`range` query**: 返回包含在提供范围内的词的文档。
6. **`regexp` query**: 返回包含匹配正则表达式的词的文档。
7. **`term` query**: 返回包含提供字段中的精确词的文档。
8. **`terms` query**: 返回包含提供字段中一个或多个精确词的文档。
9. **`terms_set` query**: 返回包含提供字段中最少数量的精确词的文档。可以使用字段或脚本定义匹配词的最小数量。
10. **`wildcard` query**: 返回包含匹配通配符模式的词的文档。

### [Full-text searches](https://www.elastic.co/guide/en/elasticsearch/reference/current/full-text-queries.html)

Full-text queries 主要用于搜索分析过的文本字段，如电子邮件的正文或文章的内容。这种查询类型会对查询字符串进行分析，然后在已经分析和索引的文本字段中查找匹配的项。

全文查询的主要目标是理解查询字符串的含义，并找到最相关的结果。为了实现这一点，它会使用在索引过程中应用于字段的同一分析器来处理查询字符串。这意味着，如果字段在索引时被拆分成了多个单词（或术语），那么查询字符串也会被同样地拆分，然后 Elasticsearch 会尝试找到匹配这些术语的文档。

全文查询还支持更复杂的搜索，如模糊匹配（允许一些拼写错误）、短语匹配（查找包含特定短语的文档）和近似匹配（查找包含接近查询字符串的词的文档）。

需要注意的是，尽管可以在关键字类型（`keyword`）字段上执行全文搜索，但这通常不是一个好主意，因为 `keyword` 字段不会被分析。这意味着 Elasticsearch 会将整个字段值作为一个单一的词条来处理，这可能不会返回期望的结果。如果想要在一个字段上执行全文搜索，应该将这个字段映射为 `text` 类型。

以下是全文查询（Full-text queries）的列表:

1. **`intervals` query**: 一种全文查询，允许对匹配项的顺序和接近度进行细粒度控制。

2. **`match` query**: 执行全文查询的标准查询，包括模糊匹配和短语或接近度查询。

3. **`match_bool_prefix` query**: 创建一个布尔查询，该查询将每个词作为词查询匹配，除了最后一个词，它被作为前缀查询匹配。

4. **`match_phrase` query**: 类似于匹配查询，但用于匹配精确的短语或词接近度匹配。

5. **`match_phrase_prefix` query**: 类似于 match_phrase 查询，但对最后一个词进行通配符搜索。

6. **`multi_match` query**: match 查询的多字段版本。

7. **`combined_fields` query**: 在多个字段上进行匹配，就像它们已经被索引到一个组合字段中一样。

8. **`query_string` query**: 支持紧凑的 Lucene 查询字符串语法，允许在单个查询字符串中指定 AND|OR|NOT 条件和多字段搜索。仅适用于专家用户。

9. **`simple_query_string` query**: query_string 语法的更简单、更健壮的版本，适合直接向用户展示。

### [Compound queries](https://www.elastic.co/guide/en/elasticsearch/reference/current/compound-queries.html)

Compound queries 可以包装其他复合查询或叶子查询，以组合它们的结果和评分，改变它们的行为，或者从查询上下文切换到过滤器上下文。以下是 Compound queries 的列表:

1. **`bool` query**: 组合多个叶子或复合查询子句的默认查询，如 must、should、must_not 或 filter 子句。must 和 should 子句的评分会被组合 - 匹配的子句越多，结果越好 - 而 must_not 和 filter 子句则在过滤器上下文中执行。

2. **`boosting` query**: 返回匹配正向查询的文档，但降低同时匹配负向查询的文档的评分。

3. **`constant_score` query**: 将所有匹配的文档赋予一个统一的常数得分，这对于只关心文档是否匹配查询，而不关心它们如何匹配或匹配程度的场景非常有用。

4. **`dis_max` query**: 接受多个查询的查询，并返回匹配任何查询子句的任何文档。虽然 bool 查询会组合所有匹配查询的评分，但 dis_max 查询使用单个最佳匹配查询子句的评分。

5. **`function_score` query**: 使用函数修改主查询返回的评分，以考虑诸如流行度、最近性、距离或使用脚本实现的自定义算法等因素。

## [Aggregations](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations.html)

Aggregations 是 Elasticsearch 中的一个功能，它可以对数据进行汇总，生成度量、统计或其他分析结果。Aggregations 可以帮助回答如下问题:

- 网站的平均加载时间是多少？
- 基于交易量，最有价值的客户是谁？
- 在网络上，什么可以被认为是一个大文件？
- 每个产品类别中有多少产品？

Elasticsearch 将 aggregations 分为三类:

- Metric aggregations: 主要用于对文档字段进行各种数学运算，以生成统计信息。这些运算可以包括但不限于求和、平均值、最大值、最小值、计数等。

  例如，计算一个数字字段的平均值，或者统计一个文本字段中某个词出现的次数。这些统计信息可以帮助理解和分析的数据。

- Bucket aggregations: 主要作用是根据特定的条件将文档分组到不同的"桶"（buckets）中。每个"桶"都对应一个特定的条件，满足该条件的文档都会被放入该"桶"。这些条件可以基于字段的值、范围、存在性等。Bucket Aggregations 可以嵌套使用，这意味着可以在一个"桶"内部进行进一步的分组。

  例如，创建一个 Bucket Aggregation 来根据"国家"字段的值将文档分组，这样每个"桶"就对应一个国家，桶中的文档都是该国家的文档。由于支持嵌套，可以在每个国家的"桶"内部再创建一个 Bucket Aggregation 来根据"城市"字段的值将文档进一步分组。

- Pipeline aggregations: 主要作用是对其他聚合的结果进行二次聚合。这意味着 Pipeline Aggregations 的输入是其他聚合的结果。

  例如，使用一个 Pipeline Aggregation 来计算一个 Bucket Aggregation 的平均值，或者找出一个 Metric Aggregation 的最大值。这使得可以进行更复杂的数据分析，例如计算移动平均、累计和、百分比等。

## References

- [Elasticsearch in Action, Second Edition](https://github.com/madhusudhankonda/elasticsearch-in-action)
- [Elasticsearch 8.x Cookbook](https://github.com/PacktPublishing/Elasticsearch-8.x-Cookbook)
- [Elastic Stack 8.x Cookbook](https://github.com/PacktPublishing/Elastic-Stack-8.x-Cookbook)
- https://github.com/elastic/dockerfiles
- https://www.elastic.co/use-cases/
- https://www.elastic.co/blog/a-heap-of-trouble
- https://www.elastic.co/blog/every-shard-deserves-a-home
