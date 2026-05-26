# 仓颉文件读写语法说明

这份文档配合本项目的 `src/main.cj` 阅读，重点解释通讯录系统里用到的文件读写语法。

## 1. 引入文件相关包

```cj
import std.fs.*
import std.io.*
```

- `std.fs`：提供文件路径、文件打开、文件是否存在等功能。
- `std.io`：提供读取文件全部内容等输入输出辅助函数。

## 2. 表示文件路径

```cj
let filePath: Path = Path("./contacts.txt")
```

`Path` 表示文件路径。`"./contacts.txt"` 表示当前项目目录下的 `contacts.txt` 文件。

## 3. 判断文件是否存在

```cj
if (!exists(filePath)) {
    println("没有找到数据文件")
}
```

`exists(filePath)` 用来判断文件是否存在。

## 4. 写入文件

```cj
var file: File = File(filePath, Write)
file.write("张三\t13800000000\tzhangsan@qq.com\t北京\n".toArray())
file.close()
```

- `File(filePath, Write)`：以写入模式打开文件。
- `Write` 模式会创建文件；如果文件已经存在，会清空原来的内容。
- `write(...)` 写入的是字节数组，所以字符串要先用 `.toArray()` 转换。
- `close()` 表示关闭文件，写完后应该关闭。

## 5. 读取文件

```cj
var file: File = File(filePath, Read)
let allBytes: Array<Byte> = readToEnd(file)
file.close()
let content = String.fromUtf8(allBytes)
```

- `File(filePath, Read)`：以只读模式打开文件。
- `readToEnd(file)`：读取整个文件内容，结果是字节数组。
- `String.fromUtf8(allBytes)`：把字节数组转换成字符串。

## 6. 按行处理文本

```cj
var iter = content.lines()

while (true) {
    match (iter.next()) {
        case Some(line) => println(line)
        case None => break
    }
}
```

`lines()` 会把字符串按行拆开，返回一个迭代器。

## 7. 按分隔符拆分一行

本项目保存一条联系人时，字段之间用制表符 `\t` 分隔。

```cj
var iter = line.lazySplit("\t")
```

例如文件里一行是：

```text
张三    13800000000    zhangsan@qq.com    北京
```

程序会依次拆出姓名、电话、邮箱、地址。

## 8. 本项目中的保存逻辑

```cj
let line = "${contacts[i].name}\t${contacts[i].phone}\t${contacts[i].email}\t${contacts[i].address}\n"
file.write(line.toArray())
```

每个联系人写成一行：

- `\t`：字段之间的分隔符
- `\n`：换行，表示这一条联系人结束

## 9. 本项目中的加载逻辑

加载时主要分三步：

1. 用 `readToEnd(file)` 读取整个文件
2. 用 `content.lines()` 按行读取
3. 用 `line.lazySplit("\t")` 把一行拆成姓名、电话、邮箱、地址

这样就能把文件里的内容重新变成 `Contact` 对象。

## 10. 常见错误

- 忘记 `import std.fs.*`：会找不到 `File`、`Path`、`exists`
- 忘记 `import std.io.*`：会找不到 `readToEnd`
- 写文件后忘记 `close()`：可能导致内容没有完整保存
- 读取不存在的文件：应该先用 `exists(filePath)` 判断
- 分隔符不统一：保存用 `\t`，加载也必须用 `\t`

## 参考资料

- 仓颉标准库 `std.fs` File 示例
- 仓颉标准库 `std.fs` OpenMode 说明
- 仓颉标准库 `String.lines` 与 `lazySplit` 说明
