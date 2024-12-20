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

### 更新操作符

| 操作符名称   | 描述                               | 示例 |
| ------------ | ---------------------------------- | ---- |
| $currentDate | 设置为当前时间                     |      |
| $inc         | 原子级增减操作                     |      |
| $min         | 当传入的值比数据库中的值小时才更新 |      |
| $max         | 当传入的值比数据库中的值大时才更新 |      |
| $mul         | 原子级相乘                         |      |
| $rename      | 重命名字段                         |      |
| $set         | 设置字段值                         |      |
| $setOnInsert | 仅当                               |      |
| $unset       | 移除字段                           |      |



### updateOne

用于文档中部分字段的更新。

```
db.author.updateOne(
{"name":"bobo"},
{	
	$set:{"age":20,"view":1},
	$inc:{"view",-2}
}) 
```

方法的第一个参数是更新的条件，第二个是更新的内容。

```
db.author.updateOne(
    {"name":{$in:["wy","aaa"]}},
    {$inc:{"age":1.1}, $set:{"age2":NumberInt(100)}}
)
```

### updateMany

### replaceOne

用于整个文档的替换。



### 数组类型的字段更新

| 操作符名称        | 描述                                                         | 示例 |
| ----------------- | ------------------------------------------------------------ | ---- |
| $                 | 更新数组的第一个元素                                         |      |
| $[]               | 更新数组的所有元素                                           |      |
| array.index       | 按照指定下标来更新元素，下标从0开始                          |      |
| `$[<identifier>]` | 更新指定条件的元素                                           |      |
| $addToSet         | 添加元素到数组（当元素不存在于原来的数组当中），会对元素去重 |      |
| $pop              | 移除第一个或者最后一个元素，-1表示移除第一个，1表示移除最后一个 |      |
| $pull             | 移除符合条件的数组元素                                       |      |
| $push             | 添加元素，`$each`：添加多个元素；`$slice`：对数据切割；`$sort`：对数组进行排序；`$position`：指入插入的位置 |      |
| $pullAll          | 移除指定元素                                                 |      |

#### `$[<identifier>]`

`$[<identifier>]`用于object类型的数组操作。根据 identifier 替换符来作为条件来更新数组元素。

文档数据如下：

```
{
    "_id" : ObjectId("5fb0e99910581bd335504686"),
    "title" : "第一个问题",
    "tags" : [ 
        "bbb", 
        "ccc"
    ],
    "best" : [ 
        {
            "content" : "da1"
        }, 
        {
            "content" : "da2"
        }, 
        {
            "content" : "da3"
        }
    ]
}
```

将best中的object元素的content属性的值为da1的改为da221：

```
db.questions.updateOne(
{"tags":{$in:["aaa"]}},
{$set:{"best.$[elem].content":"da221"}}, {"arrayFilters":[{"elem.content":"da1"}]}
)
```

其中`$set:{"best.$[elem].content":"da221"}`为替换符，elem相当于迭代器中的一个变量。

#### `$`

```
.updateOne(
{"tags":{$in:["AAA"]}},
{$set:{"tags.$":"CCC"}})
```

`$`表示的是筛选结果后的第一个元素。

#### array.index

下标从0开始

```
db.questions.updateOne(
{"tags":{$in:["AA"]}},
{$set:{"tags.1":"fff"}})
```

#### $addToSet

```
db.questions.updateOne(
{"tags":{$in:["AA"]}},
{$addToSet:{"tags":"gg"}})
```

#### $pop

移除第一个：

```
db.questions.updateOne(
{"tags":{$in:["AA"]}},
{$pop:{"tags":-1}})
```

移除最后一个，设为1。

#### $pull

将包含“fff”的tags数组找到，然后移除其中包含了元素为“gg”的元素。

```
db.questions.updateOne(
{"tags":{$in:["fff"]}},
{$pull:{"tags":{$in:["gg"]}}})
```

#### $pullAll

同时移除“bbb“和”ccc“：

```
db.questions.updateOne(
{"tags":{$in:["aaa"]}},
{$pullAll:{"tags":["bbb","ccc"]}})
```

#### $push

简单push，向数组中一次添加一个元素：

```
db.questions.updateOne(
{"tags":{$in:["aaa"]}},
{$push:{"tags":"bbb"}})
```

借助`$each`操作符，一次添加多个元素：

```
db.questions.updateOne(
{"tags":{$in:["aaa"]}},
{$push:{"tags":{$each:["bbb","ccc"]}}})
```

默认添加到元素的最后面。

可以使用`$position`操作符，向指定位置添加元素。索引位置从0开始。

将元素添加到最前面：

```
db.questions.updateOne(
{"tags":{$in:["aaa"]}},
{$push:{"tags":{$each:["bbb","ccc"], $position:0}}})
```

将元素添加到下标为3的位置，即第四个元素：

```
db.questions.updateOne(
{"tags":{$in:["aaa"]}},
{$push:{"tags":{$each:["hhh"], $position:3}}})
```

使用`$slice`操作符对数组进行切割：

```

```





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

### 排序

```
db.getCollection('author').find({}).sort({"age":-1,"name":-1})
```



## 删除

删除 name 为 wy 的语句：

```
db.author.deleteOne({"name":"wy"})
```

deleteOne和deleteMany。



## 索引

可以调用explain()方法查看查询的执行情况。

```
db.getCollection('author').find({}).sort({"age":-1,"name":-1})
.explain("executionStats")
```

| 索引类型              | 说明 |
| --------------------- | ---- |
| _id                   |      |
| 单键索引              |      |
| 复合索引              |      |
| 多键索引              |      |
| 2dsphere 地理空间索引 |      |
| 文本索引              |      |

### 创建索引

```
db.author.createIndex({"name": -1 })
```

1表示升序创建，-1表示降序创建。

后台创建索引：

```
db.author.createIndex({"name": -1 } ,{background:true})
```







### 索引低效操作

- 取反效率低
- $nin 总是进行全表扫描
- 一次查询只能使用一个索引，`$or` 除外，但是`$or`使用多个索引查询之后再将结果进行合并的效率并不高，所以不推荐使用（尽可能使用`$in`）。
- 嵌套对象字段索引与基本字段的处理方式一致。





## 事务



