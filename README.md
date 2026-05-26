# 简单通讯录系统

这是一个使用仓颉语言编写的控制台通讯录项目，适合大一阶段课程设计或基础编程练习。

## 功能

- 添加联系人
- 查看所有联系人
- 按姓名查找联系人
- 修改联系人
- 删除联系人
- 退出系统

## 项目结构

```text
address_book/
├── .github/           # GitHub 协作模板
├── cjpm.toml          # 仓颉项目配置文件
├── scripts/           # GitHub 登录和发布脚本
├── src/
│   └── main.cj        # 程序源码
└── docs/
    ├── design.md      # 设计说明
    └── usage.md       # 使用说明
```

## 运行方式

请先安装仓颉工具链，并确认命令行可以使用 `cjpm`。

```bash
cjpm run
```

如果 Windows 控制台出现中文乱码，可以先执行：

```bat
chcp 65001
```

## 学习重点

- 使用 `class` 定义联系人类型
- 使用 `Array` 保存多个联系人
- 使用 `while` 循环遍历数组
- 使用函数拆分添加、查找、修改、删除等功能
- 使用 `cjpm.toml` 管理仓颉项目

## 项目管理

- [CHANGELOG.md](CHANGELOG.md)：版本更新记录
- [CONTRIBUTING.md](CONTRIBUTING.md)：同学协作说明
- [docs/design.md](docs/design.md)：系统设计说明
- [docs/usage.md](docs/usage.md)：运行和测试建议
- [scripts/github-login.ps1](scripts/github-login.ps1)：GitHub 登录脚本
- [scripts/github-publish.ps1](scripts/github-publish.ps1)：创建仓库并推送脚本

## 上传到 GitHub

如果已经配置好 Git 和 GitHub CLI，可以先登录：

```powershell
.\scripts\github-login.ps1
```

登录完成后发布到 GitHub：

```powershell
.\scripts\github-publish.ps1
```

默认会创建公开仓库 `address-book-cangjie`。如果想改仓库名：

```powershell
.\scripts\github-publish.ps1 -RepoName my-address-book
```

## 适合继续完善的方向

- 增加文件保存功能，让关闭程序后联系人不会丢失
- 增加手机号格式检查
- 支持按电话查找联系人
- 把菜单选择改成 `match` 写法
