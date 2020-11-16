# MongoDB 的介绍与使用

[TOC]

## MongoDB 介绍

| Mongo              | MySql    |
| ------------------ | -------- |
| database           | database |
| collection（集合） | table    |
| document（文档）   | row      |
| field（字段）      | column   |

### Mongo 注意事项

- 数据库的名称是区分大小写的，不能包含以下字符，如：`/\."$*<>:|?`，并且名称的长度不能超过64个字符。
- 集合的名称不能包含`$`，不能为空，不能包含null，不能以`system.`开头。
- 字段名不能为空，不能包含null，顶级字段不能以$开头，_id 是保留字段名称。

### Mongo BSON 类型





## 插入

### insert

用于插入单个文档。

```
db.questions.insert( 
{  
    "_id":"003",
    "title":"第三个问题", 
    "view":0,
    "isDeleted":false,
    "content":"第三个问题", 
    "status":"open", 
    "tags":["c#"], 
    "anwsers":[
        {"content":"回答1"},
        {"content":"回答2"},
        {"content":"回答3"}
        ]
 } 
)
```

`_id` 可以不用手动的指定，默认将会插入一个全局的id，也可以使用上述方式手动写入`_id`。

### insertOne

```
db.author.insertOne({"name":"wy", "age":18}) 
db.author.insertOne({"name":"cc", "age":28}) 
```



### insertMany

用于批量插入多个文档。

insertMany传入的是一个数组。

```
db.author.insertMany([
    {
        "name":"aaa",
        "age":22
    },
    {
		"name":"bbb",
		"age":33
    }
])
```



## 更新

```
db.author.updateOne({"name":"bobo"},
{	
	$set:{"age":20},
	$inc:{"view",-2}
}) 
```

方法的第一个参数是更新的条件，第二个是更新的内容。



## 查询

查询语句中的条件部分是一个json对象，格式如下：

```
{
	"字段名1":{操作符1: 条件值1 },
	"字段名2":{操作符2: 条件值2 }
}
```

其中操作符常见的有：`$gt`，`$gte`，`$eq`等，其中`$eq`操作符，可以简写为`"字段名":条件值`的形式。

在查询条件中指定的字段名可以重复使用多次，例如，查询age大于等于20并且小于30的数据：

```
.find({
	"age":{$gte:20},
	"age":{$lt:30}
})
```

查询语句需要注意的重点：

- 无论是查询条件部分还是返回的结果部分，均是标准的JSON对象。

### 常用操作符

| Name   | 描述                                       | 示例                          |
| ------ | ------------------------------------------ | ----------------------------- |
| `$eq`  | 等于（默认形式）                           | find({"name":"wy"})           |
| `$gt`  | 大于                                       |                               |
| `$gte` | 大于等于                                   |                               |
| `$in`  | 存在于，对应的条件值表达式一般是数组类型   | `find({"age":{$in:[20,30]}})` |
| `$lt`  | 小于                                       |                               |
| `$lte` | 小于等于                                   |                               |
| `$ne`  | 不等于                                     |                               |
| `$nin` | 不存在于，对应的条件值表达式一般是数组类型 |                               |

### 查询逻辑

| Name       | 描述                                                         | 示例                                                         |
| ---------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| $and       | 同时满足多个条件                                             |                                                              |
| $or        | 满足多个条件中的一个，条件表达式是数组类型                   | 查询出age是22或30的，或name为“wy”的数据：find(	{$or:[  {"age":{$in:[22,30]} } ,   	{"name":"wy"}	]}) |
| $not       | 不匹配，相当于sqlserver中的非（!）或not，$not支持的是object类型表达式 | 查询出name的值不是“wy”的数据：find({ "name":{$not:{$eq:"wy"}}    }) |
| $nor       | 多个条件，一个都不满足，和`$not`不同的地方在于`$nor`支持的是数组类型的表达式 | 查询出name的值既不是“wy”，也不是“aaa”的数据：find({  $nor:[ {"name":"wy"},{"name":"aaa"} ]    }) |
| $exists    | 存在某个字段                                                 | 查询存在best字段的数据：find({"best":{$exists:1}})，如果要查询没有best字段的文档数据，使用0； |
| $type      | 字段的类型                                                   | 查询字段title的值是int类型的数据：find({"title":{$type:16}})，16来自于官方的BSON Type说明。 |
| $all       | 和`$in`不同的是，`$in`只要满足其中一个即可，`$all`是全部要满足 | 查询出tags.name字段的值必须包含T1和T4两个值的数据：find({"tags.name":{$all:["T1","T4"]}}) |
| $size      | 指定长度的数组                                               | 查询出tags的数组长度为2的数据：find({"tags":{$size:3}})      |
| $elemMatch | 用于object类型数组的查询                                     | 查询tags数组中的属性name值为T1的文档数据：find({"tags":{$elemMatch:{"name":{$eq:"T1"}}}}) |

$or 的示例：

```
.find({  $or:[ { "age":{$in:[22,30]} },{"name":"wy"} ]  })
```

$not的示例：

```
find({ "name":{$not:{$eq:"wy"}}    })
```

$nor的示例：

```
find({  $nor:[ {"name":"wy"},{"name":"aaa"} ]    })
```



### 带有条件的查询语句

示例一，查询 name 为 wy 的语句：

```
db.getCollection('author').find({"name":"wy"})
```

或

```
db.getCollection('author').find({"name":{"$eq":"wy"}})
```

示例二，查询 age>20 的语句：

```
db.getCollection('author').find({"age":{"$gt":20}})
```

### 返回指定的项

示例一，返回 author 中的 name 列：

```
db.getCollection('author').find({},{"name":1})
```

1表示显示列，0表示隐藏列，上述的结果默认是带有_id 列的，如果不想显示 _id 列，可以指定其为0，如下：

```
db.getCollection('author').find({},{"name":1 ,"_id":0})
```

在使用find()函数值，该函数的第一个参数是指定查询的条件，如果没有条件，就指定为一个空 json 对象；第二个参数代表将要返回的项对应的 json 对象。

### 返回指定条目

在查询的结果集中，跳过第1条记录，返回2条记录：

```
db.getCollection('author').find(
	{"age":{"$gt":20}},
	{"name":1,"age":1 ,"_id":0}
).skip(1).limit(2)
```

### 复杂查询

假如存在如下格式的document：

```json
{
    "_id" : ObjectId("5fb0eabf10581bd3355046dc"),
    "title" : "第3个问题",
    "tags" : [ 
        {
            "name" : "T1"
        }, 
        {
            "name" : "T2"
        }, 
        {
            "name" : "T3"
        }
    ],
    "best" : {
        "content" : "ccc"
    }
}
```

如果需要查询best.content为ccc的数据：

```
db.getCollection('questions').find({"best.content":{$eq:"ccc"}})
```



### 数组的查询

#### $all

使用$all查询tags.name必须包含T1和T4的数据：

```
db.getCollection('questions').find({"tags.name":{$all:["T1","T4"]}})
```

#### $size

查询tags的数组长度为3的文档数据：

```
db.getCollection('questions').find({"tags":{$size:3}})
```

#### $elemMatch

`$elemMatch`用于Object类型数组的数据筛选，例如，查询出tags数组中的每个元素的name字段的值为“T1”的文档数据：

```
db.getCollection('questions').find({"tags":{$elemMatch:{"name":{$eq:"T1"}}}})
```

上述语句等同于：

```
db.getCollection('questions').find({"tags.name":{$eq:"T4"}})
```

虽然上述两个语句得到的结果相同，但是，$elemMatch后面可以继续使用查询表达式，还可以接着使用各种操作符，提供了更高的灵活性。

## 删除

删除 name 为 wy 的语句：

```
db.author.deleteOne({"name":"wy"})
```





 