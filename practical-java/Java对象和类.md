# Java对象和类



## 面向对象程序设计（OOP）

#### 类

类（ class) 是构造对象的模板或蓝图。由类构造 （construct ) 对象的过程称为创建类的实例 （instance ) 。在 Java 中， 所有的类都源自于Object类。

类名一般是名词，类中的方法名一般是动词。

在类之间， 最常见的关系有：

- 依赖 （“ uses-a”）：如果一个类的方法操纵另一个类的对象，我们就说一个类依赖于另一个类。（实际开发中，应该尽可能地将相互依赖的类减至最少，即让类之间的耦合度最小）
- 聚合（“ has-a”）：类 A 的对象包含类 B 的对象。
- 继承（“ is-a”） 

 UML (` Unified Modeling Language`, 统一建模语言）

#### 对象与对象变量

要想使用对象，就必须首先构造对象， 并指定其初始状态。然后，对对象应用方法。在 Java 程序设计语言中， 使用构造器（ `constructor`) 构造新实例。 构造器是一种特殊的方法， 用来构造并初始化对象。构造器的名字应该与类名相同。

一个对象变量并没有实际包含一个对象，而仅仅引用一个对象。在 Java 中，任何对象变量的值都是对存储在另外一个地方的一个对象的引用。`new `操作符的返回值也是一个引用。这是因为，所有的 Java 对象都存储在堆中。 当一个对象包含另一个对象变量时， 这个变量依然包含着指向另一个堆对象的指针。在 Java中， 必须使用` clone `方法获得对象的完整拷贝 „

局部变量不会自动地初始化为 `null`，而必须通过调用`new`或将它们设置为`null`进行初始化。



## 用户自定义类

使用一个示例来说明自定义类需要注意的地方，在本示例中，定义了`EmployeeTest`类和`Employee`类，并且这两个类位于同一个源文件`EmployeeTest.java`中：

```java
import java.time.LocalDate;

public class EmployeeTest {
    public static void main(String[] args) {
        Employee [] staff=new Employee[3];
        staff[0]=new Employee("张三",12000,1992,12,3);
        staff[1]=new Employee("李四",11080,1994,8,22);
        staff[2]=new Employee("王五",10000,1991,4,12);

        for(Employee e:staff){
            e.raiseSaleary(5);
        }

        for(Employee e: staff){
            System.out.println("name="+e.getName()
                    +",salary="+e.getSalary()+
                    ",hireDay="+e.getHireDay());
        }
    }
}
class Employee {
    private String name;
    private double salary;
    private LocalDate hireDay;

    public  Employee(String n,double s, int year,int month,int day){
        name=n;
        salary=s;
        hireDay=LocalDate.of(year,month,day);
    }

    public  String getName(){
        return name;
    }

    public  double getSalary(){
        return salary;
    }

    public LocalDate getHireDay() {
        return hireDay;
    }

    public void raiseSaleary(double byPercent){
        double raise=salary*byPercent/100;
        salary+=raise;
    }
}
```

- 如果一个源文件中，只包含一个类，那么这个类的名称必须和源文件名相同。
- 如果一个源文件中，包含多个类，只能有一个类是公有类（`public`修饰），但可以有任意数目的非公有类。并且，公有类的名称必须和源文件名相同。

#### final修饰类成员（常量）

可以将类的成员变量定义为 `final`。 构建对象时必须初始化这样的变量。也就是说， 必须确保在每一个构造器执行之后， 这个变量的值被设置， 并且在后面的操作中， 不能够再对它进行修改。

`final`修饰符大都应用于基本 （`primitive`) 类型变量，或不可变（`immutable`) 类的成员（如果类中的每个方法都不会改变其对象， 这种类就是不可变的类。 例如，`String`类就是一个不可变的类 )。



## 静态常量和静态方法

静态成员属于类，不属于任何独立的对象。

#### 静态常量

在类中使用static final修饰的变量。

#### 静态方法

在类中，使用static修饰的方法。

静态方法中，不能使用this隐式参数。

*在java中，静态方法可以使用实例对象进行调用*，但是一般不建议这么做，应该使用类名来调用静态方法。



## 对象构造

#### 重载方法

多个方法有相同的名字，不同的参数，便是重载。

#### 变量初始化

如果在构造器中没有显式地给类中的变量赋予初值，那么就会被自动地赋为默认值： 数值为`0`、布尔值为 `false`、 对象引用为 `null`。

#### 无参数的构造方法

如果在编写一个类时没有编写构造器， 那么系统就会提供一个无参数构造器。这个构造器将所有的实例域设置为默认值。于是， 实例域中的数值型数据设置为 `0`、 布尔型数据设置为 `false`、 所有对象变量将设置为 `null`。

如果类中提供了至少一个构造器， 但是没有提供无参数的构造器， 则在构造对象时如果没有提供参数就会被视为不合法。

请记住， 仅当类没有提供任何构造器的时候， 系统才会提供一个默认的构造器。

#### 构造方法调用另一个构造方法

使用`this(...)`这种形式调用同一个类中的其他构造方法。

```java
public Employee(double s)
{
	// calls Employee(String, double)
	this("Employee #" + nextld, s);
	nextld++;
}
```

#### 初始化块和静态域

首先得知道什么是块，在java中，块是使用大括号（`{}`）包裹的一个代码片段。在一个类的声明中，可以直接包含多个代码块，分为静态初始化块和非静态初始化块。 只要构造类的对象，这些块就会被执行。

```java
class Employee
{
	private static int nextld;
	private int id;
	private String name;
	private double salary;
	//这里包含一个块
    //如果不加“{}”，程序将会提示错误（逻辑处理必须要在方法或代码块中进行）
	{
		id = nextld;
		nextld++;
	}
    //这里是静态域初始化
    static
	{
		Random generator = new Random0；
		nextld = generator.nextlnt(lOOOO) ;
	}
	public Employee(String n, double s)
	{
		name=n;
		salary = s;
	}
}
```

在这个示例中， 无论使用哪个构造器构造对象， `id`域都在对象初始化块中被初始化。首先运行初始化块，然后才运行构造器的主体部分。这种机制不是必需的，也不常见。通常会直接将初始化代码放在构造器中。

静态域初始化

在类第一次加载的时候， 将会进行静态域的初始化。与实例域一样，除非将它们显式地设置成其他值， 否则默认的初始值是 `0`、 `false` 或 `null`。 所有的静态初始化语句以及静态初始化块都将依照类定义的顺序执行。

#### 对象析构与 finalize 方法

析构器方法用于放置一些当对象不再使用时需要执行的清理代码。在析构器中， 最常见的操作是回收分配给对象的存储空间。由于 Java 有自动的垃圾回收器，不需要人工回收内存， 所以 Java 不支持析构器。

但在java中，可以为任何一个类添加 `finalize`方法。 `finalize`方法将在垃圾回收器清除对象之前调用。在实际应用中，不要依赖于使用 `finalize`方法回收任何短缺的资源， 这是因为很难知道这个方法什么时候才能够调用。



## 包

使用包的主要原因是确保类名的唯一性。

#### 类的导入

方式一：在代码中使用该类所在的完整的包名进行引用。例如：`java.tiie.LocalDate today = java.tine.Local Date.now() ;`

方式二：使用`import`语句。可以使用`import`语句导人一个特定的类或者整个包。`import` 语句应该位于源文件的顶部，但位于 `package` 语句的后面。例如， 可以使用下面这条语句导人`java.util` 包中所有的类：`import java.util.*;`注意：只能使用星号（`*`) 导入一个包， 而不能使用 `import java.*` 或`import java.*.*` 导入以 `java` 为前缀的所有包。

#### 静态导入

`import` 语句不仅可以导人类，还增加了导人静态方法和静态域的功能。例如：

```java
import static java.lang.System.*;
```

就可以使用 `System` 类的静态方法和静态域，而不必加类名前缀：

```java
out.println("Goodbye, World!"); //i.e., System.out
exit⑼; //i.e., System.exit
```

另外，还可以导入特定的方法或域（不建议使用，不利于代码清晰度）：

```java
mport static java.lang.System.out;
```

`package`相当于C#中的`namespace`，`import`相当于C# 中的`using`。但是java中的`package`语句必须在源文件的开头。

#### 为类指定包名

为类指定包名的语句必须放在源文件的开头。如果没有在源文件中放置 `package` 语句， 这个源文件中的类就被放置在一个默认包( `defaulf package` ) 中。默认包是一个没有名字的包。

注意：源文件必须放到与完整的包名匹配的子目录中，例如，`com.horstmann.corejava` 包中的所有源文件应该被放置在子目录 `com/horstmann/corejava`( Windows 中 `com\horstmann\corejava`) 中。编译器将类文件也放在相同的目录结构中。

编译器对文件 （带有文件分隔符和扩展名 `.java` 的文件）进行操作。而 Java 解释器加载类（带有 . 分隔符 )。

> 编译器在编译源文件的时候不检查目录结构。 例如， 假定有一个源文件开头有下列语句：
> `package con.myconpany;`即使这个源文件没有在子目录` com/mycompany `下， 也可以进行编译。 如果它不依赖于其他包， 就不会出现编译错误。 但是， 最终的程序将无法运行， 除非先将所有类文件移到正确的位置上。 如果包与目录不匹配， 虚拟机就找不到类 。

#### 包作用域

如果没有指定 `public` 或 `private`, 这 个 部分（类、方法或变量）可以被同一个包中的所有方法访问。（注意此处和C#的不同） 

#### 类路径

类存储在文件系统的子目录中。类的路径必须与包名匹配。



## 文档注释（`/**` 和 `*/` ）

文档注释，主要是为了生成帮助文档，用来描述相关的包、类、方法等具体信息的。

对于包、类、接口、方法等信息描述注释，应该放在所描述特性的前面，注释以`/**` 开始， 并以 `*/` 结束。每个` /** . . . */ `文档注释在标记之后紧跟着自由格式文本（ free-form text )。标记由 `@`开始， 如`@author` 或`@param`。自由格式文本的第一句应该是一个概要性的句子。

在自由格式文本中，可以使用 HTML 修饰符， 例如，用于强调的 `<em>...</em>`、 用于着重强调的`<strong>...</strong>` 以及包含图像的 `<img ..>` 等。不过， 一定不要使用 `<h1> `或`<hr>`, 因为它们会与文档的格式产生冲突。若要键入等宽代码， 需使用 `{@code ... }`而不是`<code>...</code>`这样一来， 就不用操心对代码中的 `<` 字符转义了。

#### 类注释

类注释必须放在`import` 语句之后，类定义之前。

```java
/**
类说明
*/
public class Card
{
    ...
}
```

#### 方法注释

每一个方法注释必须放在所描述的方法之前。除了通用标记之外， 还可以使用下面的标记：

- `@param` 变量描述。这个标记将对当前方法的“ `param`” （参数）部分添加一个条目。这个描述可以占据多行， 并可以使用 HTML 标记。一个方法的所有 `@param` 标记必须放在一起。
- `@return` 描述。这个标记将对当前方法添加“ `return`” （返回）部分。这个描述可以跨越多行， 并可以使用 HTML 标记。
- `@throws`类描述。这个标记将添加一个注释， 用于表示这个方法有可能抛出异常。 

#### 公有变量注释

```java
/**
* The "Hearts" card suit
*/
public static final int HEARTS = 1;
```

#### 通用注释

下面的标记可以用在类文档的注释中。

- `@author` 姓名：这个标记将产生一个“`author`" (作者）条目。可以使用多个 `@author`标记，每个`@author`标记对应一个作者。
- `@version`：这个标记将产生一个“`version`”（版本）条目。这里的文本可以是对当前版本的任何描述。

下面的标记可以用于所有的文档注释中。

- `@since` 文本：这个标记将产生一个“ `since`” （始于）条目。这里的 text 可以是对引人特性的版本描述。例如， `@since version 1.7.10`。
- `@deprecated`文本：这个标记将对类、 方法或变量添加一个不再使用的注释。 文本中给出了取代的建议。例如，`@deprecated Use <code> setVIsible(true)</code> instead`通过 `@see` 和`@link`标记， 可以使用超级链接， 链接到 javadoc 文档的相关部分或外部文档。
- `@see` 引用：这个标记将在“ `see also`” 部分增加一个超级链接。


