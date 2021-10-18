# Java环境配置与jar文件说明



## Java主要术语解释

| 缩写         | 术语名                               | 解释                                                         |
| ------------ | ------------------------------------ | ------------------------------------------------------------ |
| `JDK`        | `Java Development Kit`               | Java开发工具包，编写Java程序的程序员使用的软件开发包         |
| `JRE`        | `Java Runtime Environment`           | Java运行时环境，它包含虚拟机但不包含编译器，专门为不需要编译器的用户而提供。（运行Java程序的用户使用的软件） |
| `Server JRE` | `Server（Java Runtime Environment）` | 在服务器上运行Java程序的软件                                 |
| `Java SE`    | `Java Standard Edition`              | Java的标准版，`JDK/JRE`都是基于Java SE，用于桌面或简单服务器应用的Java平台 |
| `Java EE`    | `Java Enterprise Edition`            | Java的企业版，用于复杂服务器应用的Java平台                   |
| `Java ME`    | `Java Micro Edition`                 | Java的微型版，用于手机和其他小型设备的Java平台               |
| `NetBeans`   | `NetBeans`                           | Oracle的集成开发环境                                         |
| `J2`         | `Java 2`                             | 已过时，用于描述2006年前的Java版本                           |
| `SDK`        | `Software Development Kit`           | 已过时，用于描述2006年之前的JDK                              |



## Java版本说明

`Java SE8`表示的是Java标准版的第8个版本，`Java SE 8u31`表示的是`Java SE8`的第`31`次更新，其中的字母“`u`”表示的是更新。



## Java安装配置说明

#### 下载安装JDK（`Java Development Kit`，即java开发工具包）

#### 配置环境变量

配置windows环境变量时，将JDK所在的安装目录下的bin目录(`D:\Java\jdk1.8.0_144\bin`)添加到变量路径的最前面，并用分号分隔。如果路径中有特殊符号，比如空格，需要把整个路径用双引号引起来，比如：`"D:\Java\jdk1.8.0_144\bin";` (分号在双引号外层，最好路径中不要含有空格等特殊字符)，输入`javac -version` 验证设置是否正确。

#### 安装库源文件和文档

Java库源文件在JDK目录下的`src.zip`文件，`D:\Java\jdk1.8.0_144\src.zip`，可以在主目录中建立一个`javasrc`文件夹，解压该文件到`javasrc`目录中即可。 文档是一个独立的压缩文件，不由JDK提供，需要从[官网下载](http://www.oracle.com/technetwork/java/javase/documentation/jdk8-doc-downloads-2133158.html)，文件名类似于`jdk-version-docs-all.zip`，比如：`jdk-8u144-docs-all.zip`。可以在主目录建立一个`javadoc`文件夹，解压该文件到`javadoc`目录中即可。



## 使用命令行工具运行Java程序

`javac`：`javac`程序是一个Java编译器，它将`.java`文件编译成`.class`字节码文件。编译器需要一个文件名，所以必须要有文件后缀名，该命令使用示例：`javac wy.java` 

`java`：`Java`程序启动Java虚拟机，虚拟机执行编译器放在`.class`文件中的字节码，运行程序时，只需要指定类名，不要带扩展名`.java`或`.class`。该命令使用示例：`java wy`
**注意：源代码的文件名必须与类的名称相同，并且用`.java`作为扩展名。**



## JAR文件

JAR：Java归档文件。一个jar文件既可以包含类文件，也可以包含诸如图像和声音这些其他类型的文件，此外，jar文件是压缩的，他使用了大家熟悉的ZIP压缩格式。

#### 创建JAR文件

jar工具位于JDK安装目录的bin目录下，创建一个新的JAR文件命令格式：

```
jar 选项 文件列表
```

例如：`jar cvf wy.jar *.class small.png` ，其中`cvf`是选项值，多个文件列表使用空格隔开，语法类似于linux的命令语法。

jar命令可用的选项说明：

| 选项 | 说明                                                         |
| ---- | ------------------------------------------------------------ |
| c    | 创建一个新的或者空的存档文件并加入文件。如果指定的文件名是目录，jar程序将会对它们进行递归处理 |
| C    | 暂时改变目录，例如：`jar cvf JARFileName.jar -C classes *.class`，改变classes子目录，以便增加这些类文件 |
| e    | 在清单文件中创建一个条目                                     |
| f    | 将JAR文件名指定为第二个命令行参数。如果没有这个参数，`jar`命令会将结果写到标注输出上（在创建JAR文件时）或者从标准输入中读取它（在解压或者列出JAR文件内容时） |
| i    | 建立索引文件（用于加快对大型归档的查找）·                    |
| m    | 将一个清单文件（`manifest`）添加到JAR文件中。清单是对存档内容和来源的说明。每个归档有一个默认的清单文件。但是，如果想验证归档文件的内容，可以提供自己的清单文件 |
| M    | 不为条目创建清单文件                                         |
| t    | 显示内容表                                                   |
| u    | 更新一个已有JAR文件                                          |
| v    | 生成详细的输出结果                                           |
| x    | 解压文件。如果提供了一个或多个文件名，只解压这些文件；否则，解压所有文件 |
| o    | 存储，不进行ZIP解压                                          |

#### 清单文件

每个jar文件还包含一个用于描述归档特征的清单文件。清单文件被命名为`MANIFEST.MF`，它位于jar文件的一个特殊META-INF子目录中。

复杂的清单文件可能包含多个条目，这些清单条目被分为多个节，第一节被称为主节，作用于整个jar文件。随后的条目用来指定已命名条目的属性，这些已命名的条目可以是某个文件、包或者url，他们都必须起始于名为Name的条目，节与节之间用空行隔开。

要创建一个包含清单文件的jar文件，应该运行：

```
jar cfm my.jar manifest.mf com/mycompany/mypkg/*.class
```

要想更新一个已有的jar文件的清单，需要将增加的部分放置到一个文本文件中，然后执行下列命令：

```
jar ufm Myarchive.jar manifest-additions.mf
```

#### 可执行JAR文件

可以使用`jar`命令中的`e`选项指定程序的入口点，即通常需要在调用java程序加载器时指定的类：

```
jar cvfe myapp.jar com.mycompany.mypkg.MainAppClass
```

或者，可以子啊清单中自动应用程序的主类，包括以下形式的语句：

```
Main-Class: com.mycompany.mypkg.MainAppClass
```

不要将扩展名`.calss`添加到主类名中。

注意：清单文件的最后一行必须以换行符结束，否则，清单文件将无法被正确的读取。常见的错误是创建了一个只包含`Main-Class`而没有行结束符的文本文件。



## JRE、JDK、JVM三者关系

`JRE`：包括虚拟机、java核心类库和支持文件。和`JDK`的区别：如果只需要运行java程序，下载并安装`JRE`即可如果要开发java软件，需要下载JDK，JDK中附带有JRE

JDK 包含 JRE 包含 JVM

JRE=JVM+JavaSE标准类库

JDK=JRE+开发工具集（例如Javac编译工具等）

Java EE：JavaSE为JavaEE提供基础，JavaEE主要用于网页的Web程序、JSP、Serverlit等



## 包的密封

要想密封一个包，需要将包中的所有类放在一个jar文件中。默认情况下，jar文件中的包是没有密封的，可以在清单文件的注解加入下面一行：`Sealed:true`实现密封一个包。





------



#### 参考资源

- 《Java核心技术 卷I 基础知识（原书第10版）》



本文后续会随着知识的积累不断补充和更新，内容如有错误，欢迎指正。

最后一次更新时间：2018-08-22

------

