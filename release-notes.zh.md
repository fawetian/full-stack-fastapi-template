# 发布说明

## 最新更改

### 内部

* ⬆ 将 actions/checkout 从 5 升级到 6。PR [#2074](https://github.com/fastapi/full-stack-fastapi-template/pull/2074) by [@dependabot[bot]](https://github.com/apps/dependabot)。
* 👷 添加预提交工作流。PR [#2056](https://github.com/fastapi/full-stack-fastapi-template/pull/2056) by [@YuriiMotov](https://github.com/YuriiMotov)。
* ⬆ 在 /frontend 中将 @tanstack/router-devtools 从 1.140.0 升级到 1.142.8。PR [#2060](https://github.com/fastapi/full-stack-fastapi-template/pull/2060) by [@dependabot[bot]](https://github.com/apps/dependabot)。
* ⬆ 在 /frontend 中将 @tanstack/react-router 从 1.141.2 升级到 1.142.8。PR [#2062](https://github.com/fastapi/full-stack-fastapi-template/pull/2062) by [@dependabot[bot]](https://github.com/apps/dependabot)。
* ⬆ 在 /frontend 中将 @biomejs/biome 从 2.3.8 升级到 2.3.10。PR [#2061](https://github.com/fastapi/full-stack-fastapi-template/pull/2061) by [@dependabot[bot]](https://github.com/apps/dependabot)。
* ⬆ 在 /frontend 中将 @tanstack/react-router-devtools 从 1.139.12 升级到 1.142.8。PR [#2063](https://github.com/fastapi/full-stack-fastapi-template/pull/2063) by [@dependabot[bot]](https://github.com/apps/dependabot)。
* ⬆ 在 /frontend 中将 zod 从 4.1.13 升级到 4.2.1。PR [#2064](https://github.com/fastapi/full-stack-fastapi-template/pull/2064) by [@dependabot[bot]](https://github.com/apps/dependabot)。
* 👷 配置覆盖率，在主测试上出错，不等待 Smokeshow。PR [#2054](https://github.com/fastapi/full-stack-fastapi-template/pull/2054) by [@YuriiMotov](https://github.com/YuriiMotov)。
* 👷 即使测试失败也始终运行 Smokeshow。PR [#2053](https://github.com/fastapi/full-stack-fastapi-template/pull/2053) by [@YuriiMotov](https://github.com/YuriiMotov)。

## 0.9.0

### 功能

* ✨ 为所有页面添加元标题支持。PR [#2039](https://github.com/fastapi/full-stack-fastapi-template/pull/2039) by [@alejsdev](https://github.com/alejsdev)。
* 🛂 将前端迁移到 Shadcn。PR [#2010](https://github.com/fastapi/full-stack-fastapi-template/pull/2010) by [@alejsdev](https://github.com/alejsdev)。

### 修复

* 🐛 将 `EMAILS_FROM_NAME` 类型修复为 `str` 而不是 `EmailStr`。PR [#1940](https://github.com/fastapi/full-stack-fastapi-template/pull/1940) by [@martin0258](https://github.com/martin0258)。
* 🐛 修复 `parse_cors` 函数，使其对空字符串和空列表保持一致。PR [#1672](https://github.com/fastapi/full-stack-fastapi-template/pull/1672) by [@rolkotaki](https://github.com/rolkotaki)。
* 🐛 在用户选择时关闭侧边栏抽屉。PR [#1515](https://github.com/fastapi/full-stack-fastapi-template/pull/1515) by [@dtellz](https://github.com/dtellz)。
* 🐛 修复编辑用户字段时所需的密码验证。PR [#1508](https://github.com/fastapi/full-stack-fastapi-template/pull/1508) by [@jpizquierdo](https://github.com/jpizquierdo)。

### 重构

* ♻️ 更新密码最大长度。PR [#1447](https://github.com/fastapi/full-stack-fastapi-template/pull/1447) by [@michaelAlvarino](https://github.com/michaelAlvarino)。
* 🚚 将后端测试移出 `app` 目录。PR [#1862](https://github.com/fastapi/full-stack-fastapi-template/pull/1862) by [@YuriiMotov](https://github.com/YuriiMotov)。
* ✨ 为 Vite 环境变量添加 ImportMetaEnv 和 ImportMeta 接口。PR [#1860](https://github.com/fastapi/full-stack-fastapi-template/pull/1860) by [@alejsdev](https://github.com/alejsdev)。
* 🔧 更新 `tsconfig.json` 并修复错误。PR [#1859](https://github.com/fastapi/full-stack-fastapi-template/pull/1859) by [@alejsdev](https://github.com/alejsdev)。
* ♻️ 从 ChangePassword 组件中的 Save 按钮移除 disabled 属性。PR [#1844](https://github.com/fastapi/full-stack-fastapi-template/pull/1844) by [@alejsdev](https://github.com/alejsdev)。

### 升级

* ⬆ 在 /frontend 中将 @types/react 从 19.1.12 升级到 19.1.13。PR [#1888](https://github.com/fastapi/full-stack-fastapi-template/pull/1888) by [@dependabot[bot]](https://github.com/apps/dependabot)。
* ⬆ 在 /frontend 中将 @tanstack/router-plugin 从 1.131.41 升级到 1.131.43。PR [#1887](https://github.com/fastapi/full-stack-fastapi-template/pull/1887) by [@dependabot[bot]](https://github.com/apps/dependabot)。
* ⬆ 在 /backend 中将 pydantic 从 2.11.7 升级到 2.11.9。PR [#1891](https://github.com/fastapi/full-stack-fastapi-template/pull/1891) by [@dependabot[bot]](https://github.com/apps/dependabot)。

### 文档

* 📝 添加用于本地电子邮件测试的 Mailcatcher 设置说明。PR [#2038](https://github.com/fastapi/full-stack-fastapi-template/pull/2038) by [@alejsdev](https://github.com/alejsdev)。
* 📝 更新 `README` 以包含 Vite 的链接。PR [#2037](https://github.com/fastapi/full-stack-fastapi-template/pull/2037) by [@alejsdev](https://github.com/alejsdev)。
* 📝 修复过时的工作流徽章。PR [#2028](https://github.com/fastapi/full-stack-fastapi-template/pull/2028) by [@AymanAlSuleihi](https://github.com/AymanAlSuleihi)。
* 📝 更新文档。PR [#2036](https://github.com/fastapi/full-stack-fastapi-template/pull/2036) by [@alejsdev](https://github.com/alejsdev)。
* ✏️ 修复 `deployment.md` 中的小拼写错误。PR [#1679](https://github.com/fastapi/full-stack-fastapi-template/pull/1679) by [@cassmtnr](https://github.com/cassmtnr)。

### 内部

* 🔥 移除未使用的依赖。PR [#2035](https://github.com/fastapi/full-stack-fastapi-template/pull/2035) by [@alejsdev](https://github.com/alejsdev)。

## 0.8.0

### 功能

* 🛂 迁移到 Chakra UI v3。PR [#1496](https://github.com/fastapi/full-stack-fastapi-template/pull/1496) by [@alejsdev](https://github.com/alejsdev)。
* ✨ 添加私有的、仅本地的 API，用于 E2E 测试。PR [#1429](https://github.com/fastapi/full-stack-fastapi-template/pull/1429) by [@patrick91](https://github.com/patrick91)。
* ✨ 迁移到最新的 openapi-ts。PR [#1430](https://github.com/fastapi/full-stack-fastapi-template/pull/1430) by [@patrick91](https://github.com/patrick91)。

### 修复

* 🧑‍🔧 为 'htmlFor' 替换正确的值。PR [#1456](https://github.com/fastapi/full-stack-fastapi-template/pull/1456) by [@wesenbergg](https://github.com/wesenbergg)。

### 重构

* ♻️ 如果我们收到 401/403，将用户重定向到 `login`。PR [#1501](https://github.com/fastapi/full-stack-fastapi-template/pull/1501) by [@alejsdev](https://github.com/alejsdev)。
* 🐛 重构重置密码测试，创建普通用户而不是使用超级用户。PR [#1499](https://github.com/fastapi/full-stack-fastapi-template/pull/1499) by [@alejsdev](https://github.com/alejsdev)。
* ♻️ 在 `config.py` 中将电子邮件类型从 `str` 替换为 `EmailStr`。PR [#1492](https://github.com/fastapi/full-stack-fastapi-template/pull/1492) by [@jpizquierdo](https://github.com/jpizquierdo)。

## 0.7.1

### 亮点

* 从 Poetry 迁移到 [`uv`](https://github.com/astral-sh/uv)。
* 简化和改进 Docker Compose 文件、Traefik Dockerfiles。
* 使 API 使用自己的域 `api.example.com`，前端使用 `dashboard.example.com`。如果你需要，这将使分别部署它们变得更容易。
* Docker Compose 上的后端和前端现在监听与本地开发服务器相同的端口，这样你可以停止 Docker Compose 服务并运行本地开发服务器，而无需更改前端配置。

### 功能

* 🩺 添加 DB 健康检查。PR [#1342](https://github.com/fastapi/full-stack-fastapi-template/pull/1342) by [@tiangolo](https://github.com/tiangolo)。

### 重构

* ♻️ 更新设置以使用顶级 `.env` 文件。PR [#1359](https://github.com/fastapi/full-stack-fastapi-template/pull/1359) by [@tiangolo](https://github.com/tiangolo)。
* ⬆️ 从 Poetry 迁移到 uv。PR [#1356](https://github.com/fastapi/full-stack-fastapi-template/pull/1356) by [@tiangolo](https://github.com/tiangolo)。
* 🔥 移除开发依赖和 Jupyter 的逻辑，它从未被记录，我不再使用那个技巧。PR [#1355](https://github.com/fastapi/full-stack-fastapi-template/pull/1355) by [@tiangolo](https://github.com/tiangolo)。
* ♻️ 使用 Docker Compose `watch`。PR [#1354](https://github.com/fastapi/full-stack-fastapi-template/pull/1354) by [@tiangolo](https://github.com/tiangolo)。

### 文档

* 💡 在 Dockerfile 中添加带有 uv 引用的注释。PR [#1357](https://github.com/fastapi/full-stack-fastapi-template/pull/1357) by [@tiangolo](https://github.com/tiangolo)。
* 📝 将电子邮件模板添加到 `backend/README.md`。PR [#1311](https://github.com/fastapi/full-stack-fastapi-template/pull/1311) by [@alejsdev](https://github.com/alejsdev)。

## 0.7.0

很多新功能！🎁

* 使用 Playwright 进行 E2E 测试。
* Mailcatcher 配置，用于开发和测试电子邮件处理。
* 分页。
* 数据库键的 UUID。
* 新用户注册。
* 支持部署到多个环境（staging、prod）。
* 许多重构和改进。
* 几个依赖项升级。

### 功能

* ✨ 添加用户设置 e2e 测试。PR [#1271](https://github.com/tiangolo/full-stack-fastapi-template/pull/1271) by [@alejsdev](https://github.com/alejsdev)。
* ✨ 添加重置密码 e2e 测试。PR [#1270](https://github.com/tiangolo/full-stack-fastapi-template/pull/1270) by [@alejsdev](https://github.com/alejsdev)。
* ✨ 添加注册 e2e 测试。PR [#1268](https://github.com/tiangolo/full-stack-fastapi-template/pull/1268) by [@alejsdev](https://github.com/alejsdev)。
* ✨ 添加注册并使 `OPEN_USER_REGISTRATION=True` 为默认值。PR [#1265](https://github.com/tiangolo/full-stack-fastapi-template/pull/1265) by [@alejsdev](https://github.com/alejsdev)。
* ✨ 添加登录 e2e 测试。PR [#1264](https://github.com/tiangolo/full-stack-fastapi-template/pull/1264) by [@alejsdev](https://github.com/alejsdev)。
* ✨ 添加前端/端到端测试的初始设置，使用 Playwright。PR [#1261](https://github.com/tiangolo/full-stack-fastapi-template/pull/1261) by [@alejsdev](https://github.com/alejsdev)。
* ✨ 添加 mailcatcher 配置。PR [#1244](https://github.com/tiangolo/full-stack-fastapi-template/pull/1244) by [@patrick91](https://github.com/patrick91)。
* ✨ 在项目中引入分页。PR [#1239](https://github.com/tiangolo/full-stack-fastapi-template/pull/1239) by [@patrick91](https://github.com/patrick91)。
* 🗃️ 为数据库模型和输入数据添加 max_length 验证。PR [#1233](https://github.com/tiangolo/full-stack-fastapi-template/pull/1233) by [@estebanx64](https://github.com/estebanx64)。
* ✨ 在开发构建中添加 TanStack React Query devtools。PR [#1217](https://github.com/tiangolo/full-stack-fastapi-template/pull/1217) by [@tomerb](https://github.com/tomerb)。
* ✨ 添加支持部署到同一服务器的多个环境（staging、production）。PR [#1128](https://github.com/tiangolo/full-stack-fastapi-template/pull/1128) by [@tiangolo](https://github.com/tiangolo)。

### 修复

* 🐛 修复欢迎页面以显示已登录用户。PR [#1218](https://github.com/tiangolo/full-stack-fastapi-template/pull/1218) by [@tomerb](https://github.com/tomerb)。
* 🐛 修复本地 Traefik 代理网络配置以修复网关超时。PR [#1184](https://github.com/tiangolo/full-stack-fastapi-template/pull/1184) by [@JoelGotsch](https://github.com/JoelGotsch)。
* ♻️ 修复当 .env 中第一个超级用户密码更改时的测试。PR [#1165](https://github.com/tiangolo/full-stack-fastapi-template/pull/1165) by [@billzhong](https://github.com/billzhong)。
* 🐛 修复重置密码时的错误。PR [#1171](https://github.com/tiangolo/full-stack-fastapi-template/pull/1171) by [@alejsdev](https://github.com/alejsdev)。
* 🐛 当前端有一个没有 index.html 的目录时修复 403。PR [#1094](https://github.com/tiangolo/full-stack-fastapi-template/pull/1094) by [@tiangolo](https://github.com/tiangolo)。

### 重构

* 🚨 修复 Docker 构建警告。PR [#1283](https://github.com/tiangolo/full-stack-fastapi-template/pull/1283) by [@erip](https://github.com/erip)。
* ♻️ 重新生成客户端以使用 UUID 而不是 id 整数并更新前端。PR [#1281](https://github.com/tiangolo/full-stack-fastapi-template/pull/1281) by [@rehanabdul](https://github.com/rehanabdul)。
* ♻️ 重构模型以使用级联删除关系。PR [#1276](https://github.com/tiangolo/full-stack-fastapi-template/pull/1276) by [@alejsdev](https://github.com/alejsdev)。
* 🔥 移除 `USERS_OPEN_REGISTRATION` 配置，默认启用注册。PR [#1274](https://github.com/tiangolo/full-stack-fastapi-template/pull/1274) by [@alejsdev](https://github.com/alejsdev)。
* ♻️ 编辑重构数据库模型以使用 UUID 而不是整数 ID。PR [#1259](https://github.com/tiangolo/full-stack-fastapi-template/pull/1259) by [@estebanx64](https://github.com/estebanx64)。

### 升级

* ⬆️ 将 SQLModel 更新到版本 `>=0.0.21`。PR [#1275](https://github.com/tiangolo/full-stack-fastapi-template/pull/1275) by [@alejsdev](https://github.com/alejsdev)。
* ⬆️ 升级 Traefik。PR [#1241](https://github.com/tiangolo/full-stack-fastapi-template/pull/1241) by [@tiangolo](https://github.com/tiangolo)。

### 文档

* 📝 更新从 tiangolo 仓库到 fastapi org 仓库的链接。PR [#1285](https://github.com/fastapi/full-stack-fastapi-template/pull/1285) by [@tiangolo](https://github.com/tiangolo)。
* 📝 将使用 Playwright 的端到端测试添加到前端 `README.md`。PR [#1279](https://github.com/tiangolo/full-stack-fastapi-template/pull/1279) by [@alejsdev](https://github.com/alejsdev)。

## 0.6.0

最新的 FastAPI、Pydantic、SQLModel 🚀

全新的前端，使用 React、TS、Vite、Chakra UI、TanStack Query/Router、生成的客户端/SDK 🎨

CI/CD - GitHub Actions 🤖

测试覆盖率 > 90% ✅

### 功能

* ✨ 采用 SQLModel，创建模型，开始使用它。PR [#559](https://github.com/tiangolo/full-stack-fastapi-template/pull/559) by [@tiangolo](https://github.com/tiangolo)。
* ✨ 使用新的 SQLModel 模型、简化的逻辑和新的 FastAPI Annotated 依赖项升级项目路由器。PR [#560](https://github.com/tiangolo/full-stack-fastapi-template/pull/560) by [@tiangolo](https://github.com/tiangolo)。
* ✨ 从 pgAdmin 迁移到 Adminer。PR [#692](https://github.com/tiangolo/full-stack-fastapi-template/pull/692) by [@tiangolo](https://github.com/tiangolo)。
* ✨ 添加对设置 `POSTGRES_PORT` 的支持。PR [#333](https://github.com/tiangolo/full-stack-fastapi-template/pull/333) by [@uepoch](https://github.com/uepoch)。

### 修复

* 🐛 修复 copier 以处理引号中包含空格的字符串变量。PR [#631](https://github.com/tiangolo/full-stack-fastapi-template/pull/631) by [@estebanx64](https://github.com/estebanx64)。
* 🐛 修复允许用户将电子邮件更新为他们已有的相同电子邮件。PR [#696](https://github.com/tiangolo/full-stack-fastapi-template/pull/696) by [@alejsdev](https://github.com/alejsdev)。
* 🐛 仅在使用时设置 Sentry。PR [#671](https://github.com/tiangolo/full-stack-fastapi-template/pull/671) by [@tiangolo](https://github.com/tiangolo)。

### 重构

* 🔧 添加缺失的 dotenv 变量。PR [#554](https://github.com/tiangolo/full-stack-fastapi-template/pull/554) by [@tiangolo](https://github.com/tiangolo)。
* 🔒️ 确保默认值 "changethis" 不会被部署。PR [#698](https://github.com/tiangolo/full-stack-fastapi-template/pull/698) by [@tiangolo](https://github.com/tiangolo)。
* 🔥 移除 Celery 和 Flower，它们目前未被使用也不推荐。PR [#694](https://github.com/tiangolo/full-stack-fastapi-template/pull/694) by [@tiangolo](https://github.com/tiangolo)。

### 升级

* 📌 升级 Poetry lock 依赖项。PR [#702](https://github.com/tiangolo/full-stack-fastapi-template/pull/702) by [@tiangolo](https://github.com/tiangolo)。
* ⬆️ 升级 Python 版本和依赖项。PR [#558](https://github.com/tiangolo/full-stack-fastapi-template/pull/558) by [@tiangolo](https://github.com/tiangolo)。
* ⬆️ 升级代码以支持 pydantic V2。PR [#615](https://github.com/tiangolo/full-stack-fastapi-template/pull/615) by [@estebanx64](https://github.com/estebanx64)。

### 文档

* 🦇 将暗色模式添加到 `README.md`。PR [#703](https://github.com/tiangolo/full-stack-fastapi-template/pull/703) by [@alejsdev](https://github.com/alejsdev)。
* 🚚 将项目重命名为 Full Stack FastAPI Template。PR [#699](https://github.com/tiangolo/full-stack-fastapi-template/pull/699) by [@tiangolo](https://github.com/tiangolo)。
* 📝 将 README 重构为后端、前端、部署、开发的单独 README.md 文件。PR [#639](https://github.com/tiangolo/full-stack-fastapi-template/pull/639) by [@tiangolo](https://github.com/tiangolo)。

## 0.5.0

* 使 Traefik 公共网络成为固定的默认值 `traefik-public`，如 DockerSwarm.rocks 中所做的那样，以简化开发并迭代项目生成器。PR [#150](https://github.com/tiangolo/full-stack-fastapi-template/pull/150)。
* 更新到 PostgreSQL 12。PR [#148](https://github.com/tiangolo/full-stack-fastapi-template/pull/148)。by [@RCheese](https://github.com/RCheese)。
* 使用 Poetry 进行包管理。初始 PR [#144](https://github.com/tiangolo/full-stack-fastapi-template/pull/144) by [@RCheese](https://github.com/RCheese)。

## 0.4.0

* 修复重置密码的安全性。将令牌作为 body 接收，而不是 query。PR [#34](https://github.com/tiangolo/full-stack-fastapi-template/pull/34)。
* 修复重置密码的安全性。将其作为 body 接收，而不是 query。PR [#33](https://github.com/tiangolo/full-stack-fastapi-template/pull/33) by [@dmontagu](https://github.com/dmontagu)。
* 修复初始化时的 SQLAlchemy 类查找。PR [#29](https://github.com/tiangolo/full-stack-fastapi-template/pull/29) by [@ebreton](https://github.com/ebreton)。

## 0.3.0

* PR [#14](https://github.com/tiangolo/full-stack-fastapi-template/pull/14)：
    * 更新 CRUD 工具以更好地使用类型。
    * 简化 Pydantic 模型名称，从 `UserInCreate` 到 `UserCreate` 等。
    * 升级包。
    * 添加新的通用"项目"模型、crud 工具、端点和测试。以便于重用它们来创建新功能。由于它们简单且通用（不像 Users），更容易复制粘贴并适应每个用例。
    * 更新端点/*路径操作*以简化代码并使用新工具，在 `include_router` 中使用前缀和标签。
    * 更新测试工具。
    * 更新检查规则，放宽 vulture 以减少误报。
    * 更新迁移以包含新项目。
    * 使用有关如何从后端开始的提示更新项目 README.md。

* 将 Python 升级到 3.7，因为 Celery 现在也兼容。PR [#10](https://github.com/tiangolo/full-stack-fastapi-template/pull/10) by [@ebreton](https://github.com/ebreton)。

## 0.2.2

* 修复前端在开发中劫持 /docs。使用最新的 https://github.com/tiangolo/node-frontend 和前端中的自定义 Nginx 配置。PR [#6](https://github.com/tiangolo/full-stack-fastapi-template/pull/6)。

## 0.2.1

* 修复按 ID 获取用户的*路径操作*文档。PR [#4](https://github.com/tiangolo/full-stack-fastapi-template/pull/4) by [@mpclarkson](https://github.com/mpclarkson) in FastAPI。
* 将 `/start-reload.sh` 设置为默认开发的命令覆盖。

## 0.2.0

**PR [#2](https://github.com/tiangolo/full-stack-fastapi-template/pull/2)**：

* 简化和更新后端 `Dockerfile`s。
* 重构和简化后端代码，改进命名、导入、模块和"命名空间"。
* 改进和简化 Vuex 与 TypeScript 访问器的集成。
* 标准化前端组件布局、按钮顺序等。
* 添加本地开发脚本（用于开发此项目生成器本身）。
* 向启动模块添加日志以尽早检测错误。
* 改进 FastAPI 依赖工具，以简化和减少代码（需要超级用户）。

## 0.1.2

* 修复更新自身用户的路径操作，将参数设置为 body payload。

## 0.1.1

自首次发布以来的几个错误修复，包括：

* 用户的路径操作顺序。
* 前端以正确格式发送登录数据。
* 添加 https://localhost 变体到 CORS。
