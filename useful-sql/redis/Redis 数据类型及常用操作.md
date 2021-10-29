# Redis 数据类型及常用操作







## string

### set

set命令用于设置值，如果已经存在key，会覆盖掉旧的值：

```shell
set age 18
```

在设置值的时候指定过期时间，单位是秒：

```shell
127.0.0.1:6379> set name wy ex 20
OK
127.0.0.1:6379> get name
"wy"
127.0.0.1:6379> ttl name
(integer) 12
```



### SETNX

注意：如果已经存在某个key的值，此时使用SETNX，不会被更新：

```shell
127.0.0.1:6379> get age
"30"
127.0.0.1:6379> SETNX age 33
(integer) 0
127.0.0.1:6379> get age
"30"
```

setnx只能用于设置不存在的key。

### type

查看类型：

```shell
127.0.0.1:6379> type age
string
```

### get

get命令用于获取值：

```shell
127.0.0.1:6379> get age
"18"
```

### del

del命令用于删除key：

```shell
127.0.0.1:6379> del age
(integer) 1
```

### append

拼接字符串，返回拼接后的字符串的长度。

```shell
127.0.0.1:6379> set name abc
OK
127.0.0.1:6379> get name
"abc"
127.0.0.1:6379> append name def
(integer) 6  
127.0.0.1:6379> get name
"abcdef"
```

### STRLEN 

查看字符串长度。

```shell
127.0.0.1:6379> STRLEN name
(integer) 6
```

### mget 、mset 、msetnx

同时获取或设置多个key的值。

```shell
127.0.0.1:6379> mset k1 aa k2 bb k3 cc
OK
127.0.0.1:6379> mget k1 k2 k3
1) "aa"
2) "bb"
3) "cc"
127.0.0.1:6379> 
```

msetnx 也不能设置已经存在的key的值，设置了不会影响旧值：

```shell
127.0.0.1:6379> msetnx k1 123 k2 123
(integer) 0
127.0.0.1:6379> mget k1 k2 k3
1) "aa"
2) "bb"
3) "cc"
```







### incr 和 decr

为指定key的值，进行累加和累减操作，每次执行都是加1或者减一。

注意：key的值必须是可以转换为整型的数据。

```powershell
127.0.0.1:6379> set age 18
OK
127.0.0.1:6379> incr age
(integer) 19
127.0.0.1:6379> get age
"19"
127.0.0.1:6379> decr age
(integer) 18
127.0.0.1:6379> decr age
(integer) 17
```



### incrby 和 decrby

为指定key的值，进行指定数量的累加和累减操作。

例如，每次累加5和累减10：

```shell
127.0.0.1:6379> INCRBY age 5
(integer) 22
127.0.0.1:6379> INCRBY age 5
(integer) 27
127.0.0.1:6379> DECRBY age 10
(integer) 17
127.0.0.1:6379> DECRBY age 10
(integer) 7
```



### getrange 和 setrange

getrange 将指定key的值按照索引进行截取。-1表示到最后。

```shell
127.0.0.1:6379> get name
"abcdef"
127.0.0.1:6379> getrange name 0 -1
"abcdef"
127.0.0.1:6379> getrange name 2 4
"cde"
```

setrange 按照指定索引下标替换值。

```shell
127.0.0.1:6379> SETRANGE name 1 wwwww
(integer) 6
127.0.0.1:6379> get name
"awwwww"
```



## hash

hash存储的数据结构和json对象类似，例如：

```json
{
	"user" : {
		"name" : "wy",
        "age" : "20"
	}
}
```

其中user作为key指定，其他作为一个单独对象的形式存储。

### hset 和 hget

使用hset创建key为user，值为一个对象，对象包含了name属性，name属性的值为“wy"：

```shell
127.0.0.1:6379> hset user name wy
(integer) 1
```

使用hget获取user下的name的值：

```shell
127.0.0.1:6379> hget user name
"wy"
```

hset和hget只能设置或获取单个属性的值。

### hmset 和 hmget 、hgetall

同时设置或获取多个对象的值。

```
127.0.0.1:6379> hmset user age 18 sex 男
OK
127.0.0.1:6379> hmget user name age sex
1) "wy"
2) "18"
3) "\xe7\x94\xb7"
127.0.0.1:6379> 
```

如果已经存在user，使用hmset时，会在原来的上面追加新的属性。

也可以直接使用hgetall获取对象的全部属性：

```shell
127.0.0.1:6379> hgetall user
1) "name"
2) "wy"
3) "age"
4) "18"
5) "sex"
6) "\xe7\x94\xb7"
127.0.0.1:6379> 
```

### HEXISTS

判断对象的某个属性是否存在。存在返回1，不存在返回0。

```
127.0.0.1:6379> HEXISTS user age
(integer) 1
```

### hlen

获取对象包含多少属性。

```shell
127.0.0.1:6379> hlen user
(integer) 3
```

### hkeys 和 hvals

获取当前对象包含的所有的key或value。

```
127.0.0.1:6379> hkeys user
1) "name"
2) "age"
3) "sex"
127.0.0.1:6379> hvals user
1) "wy"
2) "18"
3) "\xe7\x94\xb7"
```

### hincrby、hincrbyfloat

累加指定值。

hincrby进行整数累加，hincrbyfloat进行小数累加。

```shell
127.0.0.1:6379> HINCRBY user age 3
(integer) 21
127.0.0.1:6379> HINCRBY user age 3
(integer) 24
127.0.0.1:6379> HINCRBYFLOAT user age 1.4
"25.4"
127.0.0.1:6379> HINCRBYFLOAT user age 1.4
"26.8"
127.0.0.1:6379> 
```

### hdel

hdel不能直接删除key的整个对象，必须要指定删除的key对应的属性来一个一个的删除。

```shell
127.0.0.1:6379> HDEL user
(error) ERR wrong number of arguments for 'hdel' command
127.0.0.1:6379> HDEL user age
(integer) 1
```



## list

表示列表，允许存放重复的元素。

### lpush 和 rpush

都用于创建list并添加元素到列表中。不同的是添加元素的顺序不同。

```
127.0.0.1:6379> lpush list1 zs lb gy
(integer) 3
127.0.0.1:6379> lrange list1 0 -1
1) "gy"
2) "lb"
3) "zs"
127.0.0.1:6379> rpush list2 zs lb gy
(integer) 3
127.0.0.1:6379> lrange list2 0 -1
1) "zs"
2) "lb"
3) "gy"
```

也就是说，如果要list中存储的元素顺序和添加顺序相同，需要使用rpush指令。

### lpop 和 rpop

从list中取出并移除一个元素。不同的是取值的方向不同，一个是从左侧取出并移除元素，一个是从右侧取出并移除元素。

```shell
127.0.0.1:6379> lrange list1 0 -1
1) "cc"
2) "bb"
3) "aa"
127.0.0.1:6379> lpop list1
"cc"
127.0.0.1:6379> lrange list1 0 -1
1) "bb"
2) "aa"
```

```shell
127.0.0.1:6379> lrange list2 0 -1
1) "aa"
2) "bb"
3) "cc"
127.0.0.1:6379> rpop list2
"cc"
127.0.0.1:6379> lrange list2 0 -1
1) "aa"
2) "bb"
```

### lrange

获取列表中指定索引端之间的元素。-1 表示全部。

```
127.0.0.1:6379> lrange list1 0 -1
1) "gy"
2) "lb"
3) "zs"
```

### llen

获取列表元素长度。

```
127.0.0.1:6379> llen list2
(integer) 2
```

### lindex

获取指定索引下标的元素，索引从0开始。

```shell
127.0.0.1:6379> LRANGE list3 0 -1
1) "a"
2) "b"
3) "c"
4) "d"
5) "e"
6) "f"
127.0.0.1:6379> lindex list3 3
"d"
```

### lset

设置指定索引下标的元素的值。

```shell
127.0.0.1:6379> lset list3 3 dddddddd
OK
127.0.0.1:6379> LRANGE list3 0 -1
1) "a"
2) "b"
3) "c"
4) "dddddddd"
5) "e"
6) "f"
```

### linsert

将某个新元素插入到指定元素之前或之后。

将“bbbb”插入到元素“c”之前：

```shell
127.0.0.1:6379> linsert list3 before c bbbb
(integer) 7
127.0.0.1:6379> LRANGE list3 0 -1
1) "a"
2) "b"
3) "bbbb"
4) "c"
5) "dddddddd"
6) "e"
7) "f"
127.0.0.1:6379> 
```

将“cccc”插入到元素“bbbb”之后：

```
127.0.0.1:6379> linsert list3 after  bbbb cccc
(integer) 8
127.0.0.1:6379> LRANGE list3 0 -1
1) "a"
2) "b"
3) "bbbb"
4) "cccc"
5) "c"
6) "dddddddd"
7) "e"
8) "f"
127.0.0.1:6379> 

```

### lrem

从列表中删除指定数量的元素，适用于列表中重复元素需要移除的操作。

例如，将列表中是“bbbb”的元素删除其中的一个：

```shell
127.0.0.1:6379> lrem list3 1 bbbb
(integer) 1
```

### ltrim

截取列表中指定索引段的元素，并将截取的列表替换掉原来的列表。

ltrim操作会修改原来的列表，变成新截取的列表。

```shell
127.0.0.1:6379> LRANGE list3 0 -1
1) "a"
2) "b"
3) "cccc"
4) "c"
5) "dddddddd"
6) "e"
7) "f"
127.0.0.1:6379> ltrim list3 2 4
OK
127.0.0.1:6379> LRANGE list3 0 -1
1) "cccc"
2) "c"
3) "dddddddd"
```



## set

不允许放入重复的元素。并且元素是无序的。

### sadd

创建set，并添加元素，如果元素有重复项，会自动去重。

```
127.0.0.1:6379> sadd set2 a b c d e f a b c
(integer) 6
```

### srem

从set中删除指定元素。

```shell
127.0.0.1:6379> srem set2 d
(integer) 1
127.0.0.1:6379> SMEMBERS set2
1) "c"
2) "a"
3) "f"
4) "e"
5) "b"

```

### spop

从set中获取并移除指定数量的元素，如果不指定数量，默认是1。

```shell
127.0.0.1:6379> SMEMBERS set2
1) "c"
2) "a"
3) "f"
4) "e"
5) "b"
127.0.0.1:6379> spop set2 2
1) "b"
2) "a"
127.0.0.1:6379> spop set2
"f"
127.0.0.1:6379> SMEMBERS set2
1) "c"
2) "e"
127.0.0.1:6379> 
```

### smembers

查看set的内容。

```
127.0.0.1:6379> smembers set2
1) "c"
2) "a"
3) "d"
4) "f"
5) "e"
6) "b"
```

### srandmember

从set中随机取出指定数量的元素。

```shell
127.0.0.1:6379> srandmember set1 3
1) "d"
2) "a"
3) "b"
127.0.0.1:6379> srandmember set1 3
1) "c"
2) "d"
3) "b"
```

### scard

查看set元素的数量。

```
127.0.0.1:6379> scard set2
(integer) 6
```

### sismember

判断指定元素是否在set中。存在返回1，不存在返回0。

```
127.0.0.1:6379> sismember set2 d
(integer) 1

```

### smove

将一个set中的指定元素移动到另一个set中。

例如，将set1中的“f”移动到set2中：

```powershell
127.0.0.1:6379> SMEMBERS set1
1) "d"
2) "b"
3) "a"
4) "c"
5) "f"
6) "e"
127.0.0.1:6379> SMEMBERS set2
1) "c"
2) "e"
127.0.0.1:6379> smove set1 set2 f
(integer) 1
127.0.0.1:6379> SMEMBERS set1
1) "c"
2) "a"
3) "d"
4) "e"
5) "b"
127.0.0.1:6379> SMEMBERS set2
1) "c"
2) "f"
3) "e"
```

### sdiff

获取一个set在另一个set中不同的元素。（差集）

例如，获取set1中的不存在于set2中的元素，即：set1中有，set2中没有的元素：

```
127.0.0.1:6379> SMEMBERS set1
1) "c"
2) "a"
3) "d"
4) "e"
5) "b"
127.0.0.1:6379> SMEMBERS set2
1) "c"
2) "f"
3) "e"
127.0.0.1:6379> sdiff set1 set2
1) "b"
2) "d"
3) "a"

```

### sinter

获取同时存在于两个set中的元素。（交集）

例如，获取set1中有，并且set2中也有的元素：

```shell
127.0.0.1:6379> SMEMBERS set1
1) "c"
2) "a"
3) "d"
4) "e"
5) "b"
127.0.0.1:6379> SMEMBERS set2
1) "c"
2) "f"
3) "e"
127.0.0.1:6379> sinter set1 set2
1) "c"
2) "e"
```

### sunion

获取两个set的并集。

```shell
127.0.0.1:6379> sunion set1 set2
1) "c"
2) "a"
3) "d"
4) "f"
5) "e"
6) "b"
```



## zset

不允许放入重复的元素，元素的顺序是有序的。









## 其他语句

### select

切换当前数据库，类似于sqlserver中的use语句。

例如：切换到索引下标为1的数据库中：

```shell
127.0.0.1:6379> select 1
OK
127.0.0.1:6379[1]> 
```

### del

不管值是什么类型，都可以使用del语句来删除key。

### keys

获取所有key，不建议在生产上使用，会有性能影响。

```
keys *
```

获取以“a“开头的所有key：

```
keys a*
```

获取以“a”结尾的所有key：

```
keys *a
```

### ttl

ttl 是 time to leave 的缩写，用于查看key离过期剩余的时间，单位是秒。

```shell
127.0.0.1:6379> ttl age
(integer) -1
```

-1 表示过期时间无穷大，永不过期。

 ### expire 

expire为key设置过期时间，单位是秒。

```shell
127.0.0.1:6379> EXPIRE age 30
(integer) 1
127.0.0.1:6379> ttl age
(integer) 28
```

一旦过期之后，ttl值会变成-2，此时获取key的值时，就不存在了。

```shell
127.0.0.1:6379> ttl age
(integer) -2
127.0.0.1:6379> get age
(nil)
```

除了expire之外，也可以在set时使用如下命令设置过期时间：

```shell
127.0.0.1:6379> set name wy ex 20
OK
127.0.0.1:6379> get name
"wy"
127.0.0.1:6379> ttl name
(integer) 12
127.0.0.1:6379> 

```

效果和expire一样。



### flushdb 和 flushall

flushdb用于清空当前库的内容。

flushall用于清空全部所有库的内容。

这两个操作需谨慎，内容一旦清空后不能够恢复。

```shell
127.0.0.1:6379> flushdb
OK
127.0.0.1:6379> flushall
OK
127.0.0.1:6379> 
```

