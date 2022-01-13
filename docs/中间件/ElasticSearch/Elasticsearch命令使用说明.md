## 索引相关



### 直接复制索引到新的索引名称



```json
POST localhost:9200/_reindex
{
  "source": {
    "index": "indexName"
  },
  "dest": {
    "index": "newIndexName"
  }
}
```



### 查询复制索引到新的索引名称



```json
POST localhost:9200/_reindex
{
  "source": {
    "index": "indexName",
    "type": "typeName",
    "query": {
      "term": {
        "name": "shao"
      }
    }
  },
  "dest": {
    "index": "newIndexName"
  }
}
```



## 索引备份与恢复

[(14条消息) Elasticsearch的数据备份和恢复以及迁移_Map的博客-CSDN博客_elasticsearch数据备份](https://blog.csdn.net/finghting321/article/details/105822365?spm=1001.2101.3001.6661.1&utm_medium=distribute.pc_relevant_t0.none-task-blog-2~default~CTRLIST~default-1.no_search_link&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2~default~CTRLIST~default-1.no_search_link)