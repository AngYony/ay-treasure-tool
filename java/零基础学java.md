## bit和byte

一个二进制的位叫做一个bit，网络带宽中的单位，都是bit。100Mb/8=12MB

八个二进制的位，组成一个Byte（字节）。硬盘等存储的单位，都是Byte。



## ||与|的区别

||与|的区别：|的左边为true，依然会执行|的右边；而||的左边为true，就不会执行||的右边。

eg：`true | (10/0 > 1))`，虽然左边为true，依然会允许后边，报异常信息（被除数不能为0）



## 位运算符

按位并（AND）：&

按位或（OR）：|

按位异或（XOR）：^

按位取反：~

主要用途：掩码



## 位移运算符

`>>`：符号位不动，其余位右移，符号位后面正数补0，负数补1，又称带符号右移。

`>>>`：符号位一起右移，左边补0，又称无符号右移。

`<<`：左移，右边补0。左移没有带符号位一说，因为符号位在最左侧。

主要用途：快速除以2运算。 



## 方法

无论在一个类中定义多少方法，都不会影响创建一个对象所占用的内存。

静态变量一般使用全大写字母加下划线分隔。



## 静态代码块

```java
public static double BASE_DISCOUNT;
public static double VIP_DISCOUNT;
static {
    BASE_DISCOUNT = 0.01;
    VIP_DISCOUNT = 0.85;
}
```

注意：使用某个静态变量的代码块必须在静态变量后面。



## instanceof操作符

```java
if(m instanceof Phone)
```

表示：m指向的对象，是否是Phone的一个引用。



## final修饰符

final修饰符：不可被继承，不可被子类覆盖，不可被重新赋值。



## 使用IDEA生成hashCode和equals方法

右击 => Generate => equals() and hashCode()



## 字符串比较相关的问题

当比较两个字符串的值时，如果两个字符串的长度较小并且值相同，使用“`==`”会返回true，当字符串长度较大时，即使值相同，使用“`==`”也会返回false。因此比较字符串值得操作，应该使用equals方法，而不是使用`==`比较。



## 内部类

内部类会被认为是外部类本身的代码，所以外部类的private成员对其可见。

内部类分为：

- 静态内部类（用法和静态变量类似）
- 成员内部类（用法和成员变量类似，可以使用外部类对象的this自引用）
- 局部内部类（用法和局部变量类似）



## 匿名类

匿名类是用来创建接口或者抽象类的实例的，可以出现在任何有代码的地方。

匿名类是一种创建接口和抽象类对象的语法，任何可以new一个对象的地方，都可以使用匿名类。

匿名类只能实现/继承一个接口/抽象类，本身没有名字。

如果是在成员方法或者给成员方法赋值时创建匿名类，那么会有对外部对象的this自引用。

匿名类也可以访问外部类的private属性。 

```java
UnitSpec us=new UnitSpec() {
    private int abc=12;
    @Override
    public double getNumSpec() {
        return 0;
    }
    @Override
    public String getProduct() {
        return null;
    }
};
```

UnitSpec是一个接口，上述代码实例化了这个接口，并重写了接口中的方法。

 

## 非公有类

如果一个文件只有非公有类，那么类名和文件名可以不一样。当然文件后缀名必须是.java。

 

## try..catch新语法方式

```java
try{
	throwMultiException(0);
} catch ( ClassNotFoundException | IOException e)
{
	e.printStackTrace();
}
```

### 自动回收资源的try语句

如何让资源回收的方法自动被调用

```java
try(
	MyAutoClosableResource res1=new MyAutoClosableResource("res1");
	MyAutoClosableResource res1=new MyAutoClosableResource("res1");
){
	res1.read();
} catch (Exception e)
{
	e.printStackTrace();
}
```

MyAutoClosableResource是一个实现了AutoCloseable接口的类。

在try的后面，跟着一个小括号，在小括号中定义的内容，可以在try代码块中使用。



## 注解

注解的英文名叫做annotation。是给类，方法以及成员变量等元素增加元数据（metadata）的方式。换言之，就是描述这些元素的。和注释不同的是，这些描述会被java编译器处理而非忽略。

### 常见注解

#### @Override

用于标注重写了父类方法

#### @Deprecated

用于标注方法将被淘汰和过时。

### 自定义注解



## 并发

