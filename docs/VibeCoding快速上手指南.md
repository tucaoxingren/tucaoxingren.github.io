**Vibe Coding 快速上手指南**



本文为 AI 编程工具 Vibe Coding 完整上手教程，涵盖定义、环境安装、工具配置、Trellis 工作流、核心配置、自动更新机制、文件生成规范、实用技巧与成本优化，帮助开发者快速搭建企业级高效 AI 编码环境。



## 一、什么是 Vibe Coding

**Vibe Coding** 是一种基于 AI 大模型的轻量化、高效率、沉浸式 AI 辅助编程模式，以 “氛围式开发” 为核心，通过 Claude Code、Codex、Gemini 等 AI 编程 CLI 工具，搭配 Trellis 规范工作流，让开发者在自然对话、指令式交互中完成需求分析、架构设计、代码编写、Bug 修复与规范校验。

核心特点：

- 对话式编码，降低配置成本
- 规范自动注入，保证代码质量统一
- 支持多模型快速切换，兼顾效果与成本
- 适用于个人快速开发与团队标准化协作

### Claude Code 为何是 Vibe Coding 核心
Vibe Coding 是轻量化、沉浸式 AI 辅助编程模式，Claude Code 完美适配其核心：

沉浸式体验：CLI 形式与终端 / 编辑器深度融合，无网页切换割裂感，契合 “氛围式开发”；

全流程适配：联动 Trellis 工作流（/start//check等指令），覆盖需求分析→编码→校验全流程；

标准化 + 灵活：自动加载.trellis/spec项目规范，支持claude.md会话定制，兼顾个人 / 团队协作；

成本优化：可切换低成本国内模型，高低模型协同（高端规划 + 低成本编码）；
区别于豆包网页版仅能单点生成代码，Claude Code 是 “环境级工具”，承接 Vibe Coding 全流程辅助能力。

总结

豆包等大模型网页版是通用网页 AI，编程仅为附加功能；Claude Code 是专为 Vibe Coding 设计的 CLI 工具，从交互、工作流、定制化上完全匹配其 “轻量化、高效率、沉浸式” 核心，成为其核心载体。

## 二、基础环境安装

本教程支持 Claude、Codex、Gemini 三大主流 AI 编程模型，需提前配置基础运行环境。

1. **前置依赖配置**
  1. 使用 nvm 管理 Node.js，切换版本至 v24 及以上
  2. 确认 Python 版本为 3.10 及以上
  3. 配置系统代理，确保海外 API 正常访问
2. **核心工具安装**
  1. 打开终端执行以下命令：
```bash
# 安装 Claude Code
npm i -g @anthropic-ai/claude-code@latest
# 安装 OpenAI Codex
npm i -g @openai/codex@latest
# 安装 Google Gemini CLI
npm i -g @google/gemini-cli@latest
```
安装完成后，系统用户目录会自动生成配置文件夹：
- Windows：`C:\Users\用户名\.claude`、`.codex`、`.gemini`
- Mac/Linux：`~/.claude`、`.codex`、`.gemini`

3. **启动方式**
终端直接输入模型名称，回车即可启动：
```bash
claude  # 启动 Claude Code
codex   # 启动 Codex
gemini  # 启动 Gemini
```

## 三、API 快速切换工具（cc-switch）
cc-switch 可实现 AI 模型热切换，无需重启 Claude Code 即可切换 API 供应商，提升开发效率。
1. 下载安装
    下载地址：https://github.com/farion1231/cc-switch/releases/tag/v3.11.1

2. 配置要点
    打开工具代理总开关，启用热切换
    在设置中选择需接管的应用（Claude/Codex/Gemini）
    查看本地代理服务地址与端口，确保连接正常

## 四、Trellis 工作流配置（核心规范框架）

Trellis 是面向 Claude Code、Cursor 的 AI 编码一站式框架，可自动注入开发规范、管理任务流程，让 AI 编码更规范、高效。

### 1.官方文档

中文教程：https://docs.trytrellis.app/zh

### 2.核心功能

自动注入规范：一次编写，永久生效
自更新规范库：使用越久，AI 越贴合开发习惯
并行会话：单窗口多 `Agent` 协同作业
团队共享：共享规范，快速提升团队 AI 编码水平
会话持久化：保留上下文，无需重复配置

### 3. 命令使用规则

Claude Code：以 `/` 开头调用命令（如 `/trellis:start`）
Codex：以 `$` 开头调用命令（如 `$start`）

### 4. 标准开发流程

启动会话：`/start`（Claude）`/$start`（Codex）
前后端准备：`/before-backend-dev`、`/before-frontend-dev`
代码检查：`/check-backend`、`/check-frontend`、`/check-cross-layer`
完工校验：`/finish-work`
辅助功能：头脑风暴 `/brainstor`、Bug 分析 `/break-loop`、新成员入门 `/onboard`

### 5. Trellis 核心配置关系：`.trellis/spec` 与 `claude.md`

二者是 Trellis + Claude Code 标准化编码的核心配置，分工明确、协同工作。

#### 5.1 .trellis/spec（项目级规范仓库）

位置：项目根目录 → `.trellis/spec/`
本质：全项目可复用的编码规范库
作用：存放代码风格、命名规则、架构约束、注释标准、接口约定等
特点：一次编写、全会话共享、支持多文件分类管理
核心特性：动态自动更新，非静态文件

#### 5.2 claude.md（会话级任务指令）

位置：项目根目录 → `claude.md`
本质：当前会话的AI 提示词与任务清单
作用：告诉 AI 任务内容、需加载的规范、输出格式要求
特点：动态修改、按任务切换、需提交 Git 共享

#### 5.3 二者配合流程

通用规范写入 `.trellis/spec`
在 `claude.md` 中写明任务并引用 `spec` 规范
执行 `/start` 启动会话，`Trellis` 自动加载并约束 AI 输出
通俗理解
`.trellis/spec` = 公司统一《代码规范手册》+ AI 动态记忆库
`claude.md` = 项目《开发任务单》

### 6. `.trellis/spec` 自动更新机制

#### 6.1 核心本质

.trellis/spec 是 Trellis 的动态知识库，会在每次 AI 交互中被自动改写、追加、优化，无需人工修改。
#### 6.2 自动更新的 4 种场景

AI 自动优化规范：补全、细化规则，提升严谨性
AI 自动学习习惯：捕捉注释、异常处理等偏好并写入规范
命令触发同步：执行 `/start`、`/check-backend` 时自动修复、补齐规范
用户差异化更新：不同开发者习惯不同，spec 自动个性化适配
#### 6.3 为什么不提交 Git

动态频繁变更，会产生大量无意义提交
每个人内容不同，极易引发冲突
属于工具本地配置，不应污染项目仓库
#### 6.4 团队标准流程

`.trellis/spec`：本地维护，不提交 Git
`claude.md`：项目上下文，提交 Git

### 7. claude.md 如何生成（标准流程 + 模板）

#### 7.1 生成方式

1. `Trellis` 自动生成（推荐）
项目根目录执行：`/start` → 自动生成 `claude.md`

2. 手动新建
根目录创建 `claude.md`，填入模板即可

3. 架构师统一生成（企业标准）
架构师编写 → 推送到 Git → 全员拉取使用

#### 7.2 标准模板（可直接复制）
```markdown
# 项目信息
项目名称：XXX管理系统
项目版本：v1.0
项目描述：XXX业务后台管理系统

# 技术栈
前端：Vue3 + Element Plus + Pinia
后端：SpringBoot3 + MyBatis-Plus + MySQL
构建工具：Maven / Vite
部署方式：Docker + 内网发布

# 业务背景
用于XXX部门的XXX业务管理，包含用户、权限、订单、报表等模块。

# 开发规范引用
请遵循以下规范：
- .trellis/spec/frontend.md 前端规范
- .trellis/spec/backend.md 后端规范
- .trellis/spec/api.md 接口规范

# 输出要求
1. 代码必须符合团队规范
2. 必须包含清晰注释
3. 接口统一返回格式
4. 自动生成单元测试
5. 禁止硬编码，使用配置化
```

#### 7.3 生成后操作

执行 `/start` 加载生效
提交 Git：git add claude.md

### 8. `.trellis/spec` 初始化：接入公司统一规范实例

#### 8.1 初始化前提
公司架构 / 研发团队已输出标准化编码规范文档（如《XX 公司 Java 编码规范》《XX 前端开发规约》）
本地已完成 Trellis 基础安装，项目根目录可创建 .trellis 目录

#### 8.2 初始化步骤（企业级标准）

##### 8.2.1 创建规范目录结构
在项目根目录执行以下命令，搭建标准化 spec 目录：
```bash
# 创建核心目录
mkdir -p .trellis/spec
# 按公司规范分类创建子文件（示例）
touch .trellis/spec/frontend.md  # 前端规范
touch .trellis/spec/backend.md  # 后端规范
touch .trellis/spec/api.md      # 接口规范
touch .trellis/spec/naming.md   # 命名规范（公司统一）
touch .trellis/spec/comment.md  # 注释规范（公司统一）
touch .trellis/spec/security.md # 安全规范（公司强制）
```

##### 8.2.2 写入公司统一规范
以 .trellis/spec/backend.md（Java 后端为例）写入公司规范：
```markdown
# XX公司Java后端编码规范（v2.0）
## 1. 基础语法约束
- 代码缩进使用4个空格，禁止使用Tab
- 每行代码字符数不超过120，超出需换行
- 关键字后必须加空格（如 if、for、while）
- 方法体超过80行必须拆分，禁止超长方法

## 2. 命名规则（公司强制）
- 类名：大驼峰，前缀需体现业务域（如 OrderService、UserController）
- 方法名：小驼峰，动词+名词（如 queryOrderList、updateUserInfo）
- 常量：全大写，下划线分隔（如 MAX_RETRY_TIMES、DEFAULT_PAGE_SIZE）
- 包名：全小写，按公司域划分（com.xxcompany.business.order）

## 3. 架构约束
- 禁止在Controller层写业务逻辑，仅做参数校验/返回封装
- Service层必须实现接口，接口名以I开头（如 IOrderService）
- 数据库操作必须通过MyBatis-Plus，禁止直接写JDBC
- 异常必须抛自定义业务异常（BusinessException），禁止抛RuntimeException

## 4. 注释要求
- 类注释：必须包含作者、创建时间、业务说明
- 方法注释：必须包含入参、出参、异常说明、业务逻辑描述
- 关键业务代码块必须加行注释（如复杂计算、特殊逻辑）
```

以 .trellis/spec/security.md（公司安全规范）为例：
```markdown
# XX公司编码安全规范（强制）
## 1. 接口安全
- 所有对外接口必须加签名校验，签名密钥需配置化（禁止硬编码）
- 敏感接口（如支付、用户信息）必须加token校验+IP白名单
- 入参必须做XSS/SQL注入过滤，使用公司统一工具类 XssFilterUtil

## 2. 数据安全
- 手机号/身份证号必须脱敏存储，使用 DesensitizeUtil 工具类
- 密码必须通过BCrypt加密，禁止明文/MD5存储
- 数据库连接信息必须放在配置中心（Nacos/Apollo），禁止写在本地配置

## 3. 日志安全
- 禁止打印敏感信息（密码、token、身份证号）
- 日志级别规范：ERROR（异常）、WARN（风险）、INFO（关键流程）、DEBUG（开发调试，生产禁用）
```

##### 8.2.3 关联公司规范到 claude.md
修改 claude.md 的「开发规范引用」模块，直接关联公司规范文件：
```markdown
# 开发规范引用
请严格遵循XX公司统一编码规范，加载以下spec文件：
- .trellis/spec/frontend.md （引用公司前端规范）
- .trellis/spec/backend.md （引用公司后端规范）
- .trellis/spec/api.md      （引用公司接口规范）
- .trellis/spec/naming.md   （引用公司命名规范）
- .trellis/spec/comment.md  （引用公司注释规范）
- .trellis/spec/security.md （引用公司安全规范，强制遵守）

# 规范执行要求
1. 所有输出代码必须100%符合公司规范，不符合的需标注原因并提供修正方案
2. 若规范存在冲突，优先遵循 security.md 中的安全强制条款
3. 生成代码后需自动校验规范符合性，输出校验报告
```

初始化生效与验证
```bash
# 启动 Claude Code 并加载规范
claude
# 在会话中执行启动命令，触发规范加载
/start
# 验证：让AI生成一段后端接口代码，检查是否符合公司规范
请生成一个订单查询接口（/api/order/{id}），需符合XX公司后端+安全规范
```

#### 8.3 团队规范同步与维护
规范下发：架构师将公司标准 spec 文件包上传至 Git 私服 / 内网文档库

全员同步：开发者拉取后放入项目 .trellis/spec 目录，执行 /start 即可加载

规范更新：公司规范迭代后，架构师更新基准文件，全员重新拉取覆盖本地 spec 基础文件（自动更新会在基础规范上叠加个性化适配）

合规校验：通过 `/check-backend`、`/check-frontend` 命令，让 AI 自动校验代码是否符合公司规范

## 五、实用使用技巧
高效提问：把 Claude Code 当作资深开发工程师，直接清晰描述需求即可获得专业解答。

高低模型协同（推荐）：先用 Claude 等高端模型完整理解并拆解需求，让其生成结构清晰、步骤明确、可直接指导低级模型的编程指令；再通过 cc-switch 切换到低成本国内模型，按指令完成代码编写，兼顾效果与成本。

Skills 扩展：通过 cc-switch 配置技能，推荐开源技能仓库：https://skillsmp.com/。

报错处理：直接复制报错信息粘贴至对话框，AI 会自动给出解决方案。

UI 调整：截图粘贴至工具，无需文字描述，AI 可直接指导界面修改。

依赖缺失：执行脚本报错（如 Python 命令缺失），直接让 AI 安装对应依赖。

Token 节省：开发规范与提示词优先使用英文，减少 Token 消耗。

## 六、低成本平替方案（国内大模型）

Claude 官方订阅（200$/ 月）成本较高，推荐国内 Coding Plan 平替。

1. 首选模型（2026 年 3 月最新）

智谱 GLM 5：https://www.bigmodel.cn/glm-coding（推荐 Pro，149 元 / 月）

Minimax M2.5：https://platform.minimax.com/subscribe/coding-plan（推荐 199 元 / 月）

Kimi K2.5：https://www.kimi.com/code（推荐 199 元 / 月）

2. 海外模型中转方案

PackyAPI：https://www.packyapi.com/dashboard

Monking AI：https://www.monking.ai/console/topup

月均花费：300–400 元，推荐按量付费

3. 成本优化建议

优先按量付费，避免资源浪费

高端模型做规划，国内模型做编码，分层使用降成本