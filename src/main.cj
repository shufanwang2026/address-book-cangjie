package address_book

import std.console.*
import std.fs.*
import std.io.*

// 通讯录最大保存人数。这里使用固定容量数组，逻辑更接近大一阶段常见的数组练习。
const MAX_CONTACTS = 100

// 通讯录保存文件名。保存和加载功能都会使用这个文件。
const DATA_FILE = "./contacts.txt"

// Contact 表示一个联系人。
// 用 class 把“姓名、电话、邮箱、地址”放在一起，比四个零散变量更好管理。
class Contact {
    var name: String
    var phone: String
    var email: String
    var address: String

    init(name: String, phone: String, email: String, address: String) {
        this.name = name
        this.phone = phone
        this.email = email
        this.address = address
    }

    // 把联系人信息拼成一行文字，方便列表展示和查询展示。
    func toLine(index: Int64): String {
        return "${index}. 姓名: ${this.name} | 电话: ${this.phone} | 邮箱: ${this.email} | 地址: ${this.address}"
    }
}

// readInput 负责读取用户输入。
// Console.stdIn.readln() 可能读不到内容，所以用 getOrThrow() 取出真正的字符串。
func readInput(tip: String): String {
    Console.stdOut.write(tip)
    let input = Console.stdIn.readln()
    return input.getOrThrow()
}

// showMenu 只负责显示菜单，让 main 函数看起来更清楚。
func showMenu(): Unit {
    println("")
    println("====== 简单通讯录系统 ======")
    println("1. 录入联系人")
    println("2. 删除联系人")
    println("3. 显示所有联系人")
    println("4. 按姓名查找联系人")
    println("5. 保存到磁盘文件")
    println("6. 从磁盘文件加载")
    println("7. 修改联系人")
    println("0. 退出系统")
    println("==========================")
}

// isEmptyString 判断字符串是否为空。
// 这里没有做复杂的空格处理，保持代码简单，方便初学者理解。
func isEmptyString(text: String): Bool {
    return text == ""
}

// addContact 添加联系人。
// contacts 是数组，count 表示当前已经存了多少个联系人。
func addContact(contacts: Array<Contact>, count: Int64): Int64 {
    if (count >= contacts.size) {
        println("通讯录已满，不能继续添加。")
        return count
    }

    let name = readInput("请输入姓名: ")
    if (isEmptyString(name)) {
        println("姓名不能为空，添加失败。")
        return count
    }

    let phone = readInput("请输入电话: ")
    let email = readInput("请输入邮箱: ")
    let address = readInput("请输入地址: ")

    contacts[count] = Contact(name, phone, email, address)
    println("添加成功。")
    return count + 1
}

// listContacts 显示所有联系人。
func listContacts(contacts: Array<Contact>, count: Int64): Unit {
    if (count == 0) {
        println("当前通讯录没有联系人。")
        return
    }

    println("")
    println("------ 联系人列表 ------")
    var i: Int64 = 0
    while (i < count) {
        println(contacts[i].toLine(i + 1))
        i++
    }
}

// findByName 根据姓名查找联系人，找到就返回下标，找不到返回 -1。
// 返回下标后，修改和删除功能也可以复用这个函数。
func findByName(contacts: Array<Contact>, count: Int64, name: String): Int64 {
    var i: Int64 = 0
    while (i < count) {
        if (contacts[i].name == name) {
            return i
        }
        i++
    }
    return -1
}

// searchContact 只做查询展示，不改变通讯录内容。
func searchContact(contacts: Array<Contact>, count: Int64): Unit {
    let name = readInput("请输入要查找的姓名: ")
    let index = findByName(contacts, count, name)

    if (index == -1) {
        println("没有找到该联系人。")
    } else {
        println("查找结果:")
        println(contacts[index].toLine(index + 1))
    }
}

// updateContact 修改联系人。
// 为了简单清晰，这里让用户重新输入四项信息。
func updateContact(contacts: Array<Contact>, count: Int64): Unit {
    let oldName = readInput("请输入要修改的联系人姓名: ")
    let index = findByName(contacts, count, oldName)

    if (index == -1) {
        println("没有找到该联系人，修改失败。")
        return
    }

    println("找到联系人:")
    println(contacts[index].toLine(index + 1))

    let name = readInput("请输入新的姓名: ")
    if (isEmptyString(name)) {
        println("姓名不能为空，修改失败。")
        return
    }

    let phone = readInput("请输入新的电话: ")
    let email = readInput("请输入新的邮箱: ")
    let address = readInput("请输入新的地址: ")

    contacts[index] = Contact(name, phone, email, address)
    println("修改成功。")
}

// deleteContact 删除联系人。
// 数组不能直接“缩短”，所以删除时把后面的联系人依次往前移动一格。
func deleteContact(contacts: Array<Contact>, count: Int64): Int64 {
    let name = readInput("请输入要删除的联系人姓名: ")
    let index = findByName(contacts, count, name)

    if (index == -1) {
        println("没有找到该联系人，删除失败。")
        return count
    }

    var i = index
    while (i < count - 1) {
        contacts[i] = contacts[i + 1]
        i++
    }

    println("删除成功。")
    return count - 1
}

// saveContacts 把通讯录保存到磁盘文件中。
// 文件每一行保存一个联系人，四个字段之间用制表符 \t 分隔。
func saveContacts(contacts: Array<Contact>, count: Int64): Unit {
    let filePath: Path = Path(DATA_FILE)
    var file: File = File(filePath, Write)

    var i: Int64 = 0
    while (i < count) {
        let line = "${contacts[i].name}\t${contacts[i].phone}\t${contacts[i].email}\t${contacts[i].address}\n"
        file.write(line.toArray())
        i++
    }

    file.close()
    println("Saving file: ${DATA_FILE}")
    println("保存成功，共保存 ${count} 条联系人。")
}

// parseContactLine 把文件中的一行文字转换为一个 Contact。
// 如果这一行格式不对，就返回 None，加载时会跳过这行。
func parseContactLine(line: String): Option<Contact> {
    var iter = line.lazySplit("\t")

    match (iter.next()) {
        case Some(name) =>
            match (iter.next()) {
                case Some(phone) =>
                    match (iter.next()) {
                        case Some(email) =>
                            match (iter.next()) {
                                case Some(address) => return Some(Contact(name, phone, email, address))
                                case None => return None
                            }
                        case None => return None
                    }
                case None => return None
            }
        case None => return None
    }
}

// loadContacts 从磁盘文件中读取联系人。
// 读取成功后，会用文件中的内容覆盖当前内存里的通讯录。
func loadContacts(contacts: Array<Contact>): Int64 {
    let filePath: Path = Path(DATA_FILE)
    if (!exists(filePath)) {
        println("没有找到数据文件: ${DATA_FILE}")
        return 0
    }

    var file: File = File(filePath, Read)
    let allBytes: Array<Byte> = readToEnd(file)
    file.close()

    let content = String.fromUtf8(allBytes)
    var count: Int64 = 0
    var iter = content.lines()

    while (true) {
        match (iter.next()) {
            case Some(line) =>
                if (line != "" && count < contacts.size) {
                    match (parseContactLine(line)) {
                        case Some(contact) =>
                            contacts[count] = contact
                            count++
                        case None =>
                            println("跳过格式错误的数据行: ${line}")
                    }
                }
            case None => break
        }
    }

    println("加载成功，共加载 ${count} 条联系人。")
    return count
}

main(): Int64 {
    // 创建一个最多能保存 MAX_CONTACTS 个联系人的数组。
    // {i => Contact("", "", "", "")} 表示给数组每个位置都创建一个空联系人。
    let contacts = Array<Contact>(MAX_CONTACTS, {i => Contact("", "", "", "")})
    var count: Int64 = 0
    var running = true

    println("欢迎使用简单通讯录系统。")

    while (running) {
        showMenu()
        let choice = readInput("请选择功能: ")

        if (choice == "1") {
            count = addContact(contacts, count)
        } else if (choice == "2") {
            count = deleteContact(contacts, count)
        } else if (choice == "3") {
            listContacts(contacts, count)
        } else if (choice == "4") {
            searchContact(contacts, count)
        } else if (choice == "5") {
            saveContacts(contacts, count)
        } else if (choice == "6") {
            count = loadContacts(contacts)
        } else if (choice == "7") {
            updateContact(contacts, count)
        } else if (choice == "0") {
            running = false
            println("感谢使用，再见。")
        } else {
            println("输入有误，请重新选择。")
        }
    }

    return 0
}
