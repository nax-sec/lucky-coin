# 《幸运硬币》视觉重做委托书

## 0. 你要做的事

给 `source/index.html`（单文件，1403 行 / 59KB）做一次**纯视觉重做**。这是一个已经可玩的老虎机肉鸽游戏，玩法、数值、交互逻辑全部已完成且已调平衡。

**只改 `<style>` 里的样式，以及为了视觉效果必须新增的纯装饰性 DOM。**

不要改：游戏逻辑、数值、任何函数行为、事件绑定方式。

---

## 1. 硬约束（违反任何一条都算不合格）

1. **单文件**。所有 CSS 内联在 `<style>` 里，不引外部文件。
2. **禁止任何外部请求**。页面运行在严格 CSP 下：不能 `@import` 字体 CDN、不能 `<link>` 外部样式、不能引远程图片、不能 fetch。图形素材只能用：内联 SVG、CSS 渐变、canvas、或 `data:` URI。
3. **不要引入构建工具、框架、预处理器**。原生 CSS。
4. **中文字体只能用系统栈**（CJK 字体没法内联，几 MB 起）。现有栈是宋体做标题、苹方做正文，可以调整但必须是系统字体。
5. **不要写 `<!DOCTYPE>` / `<html>` / `<head>` / `<body>` 标签**，文件是以片段形式发布的。
6. **保留 `prefers-reduced-motion` 降级**。
7. 窄屏（≤520px）必须可用，页面**不能横向滚动**。宽内容自己 `overflow-x:auto`。

---

## 2. DOM 契约（最重要的一节）

JS 靠下面这些钩子驱动动画和状态。**改名、删除、或改变嵌套导致选择器失效，游戏会直接坏掉**（滚轮不转、结算不亮、拉杆失灵）。

### 必须保留的 id（35 个）
```
again againWin beat beatAmt beatEm beatNm buyRm closeItems closePool
coins endless gmul grid itemCount items leave level lever leverArm
meter meterBox notches openItems openPool period poolCount rent reroll
sheet spinTip spins tally toRent tokens veil
```

### JS 会动态增删的 class —— 必须有对应样式
```
cell filled rolling stopped wrecked paying pay show zero
grid skippable  beat hot big pop  coinfly  coin-bump
lever: pulled grabbing dragging disabled
meter: short
r-common / r-uncommon / r-rare / r-legend   （JS 以 "r-"+稀有度 拼接）
```

### JS 用到的选择器 —— 结构不能破坏
```
.cell > .glyph      每个格子里必须有一个 .glyph 承载符号
.cell > .pay        产出数字，JS 动态插入/移除
.tagline            卡片右上角的标签，JS 会改它的 textContent 和 color
[data-item] [data-sym] [data-up] [data-rm] [data-drop]
```

`#grid` 的直接子元素必须**正好是 30 个 `.cell`**，且顺序 = 从左到右、从上到下（JS 用 `children[r*6+c]` 定位）。不能加包裹层，不能改顺序。列数由 `--cols` 变量控制。

### 两个已埋好但**还没有样式**的钩子（请补上）
- `.cell.r-common / .r-uncommon / .r-rare / .r-legend` —— 稀有度底色
- `#notches` —— 里面是 10 个 `<i>`，class 为 `done` / `now` / 空，表示关卡进度

---

## 3. 视觉方向

主题是**民国当铺的夜晚**。现在的问题是：整页都是同一种"深色卡片"，所以显得廉价。

核心主张：**用三种材质把页面分层，让它有"东西感"**。

| 区域 | 材质 | 要点 |
|---|---|---|
| 中间机器（`.cabinet` / `#grid` / 拉杆） | **漆** + **铜** | 深黑红大漆，有磨砂颗粒；包边是铜，有高光和氧化暗部 |
| 右侧账房（`.ledger`） | **纸** | 当票／账簿，米黄泛旧，有纤维纹理、压印感、一枚红印 |
| 弹窗（`.sheet` / `.pop`） | 纸 或 漆 | 挑一种并贯彻，别又是深色卡片 |

**机器和账房必须一眼看出是两种东西。** 这是这次重做成败的关键。

### 具体想要的东西

**机箱**
- 真正的柜体：外圈铜包边（多层 box-shadow 做倒角，不要 1px 描边）
- 滚轮窗有"玻璃"：竖向渐变高光 + 四角暗角
- 六列之间有**卷轴分隔**，像真老虎机的轮鼓
- 中间一条**中奖线**（payline），细，暗金

**格子**
- 稀有度底色：常见=冷灰、少见=玉青、稀有=铜黄、传说=朱砂带辉光
- 有厚度（内阴影 + 顶部微高光），不是纯色块
- `.paying` 已有金色辉光，可以做得更讲究但**不要减弱**（它是结算演出的主角）

**拉杆**（`.lever-rail`）
- 现在的球头是径向渐变，还行但可以更像金属／胶木
- 槽可以做出金属滑轨的质感

**账房当票**
- 纸的底色 + 纤维噪点
- 数字用等宽、对齐（已有 `tabular-nums`，保持）
- 「本关租金」应该像盖了章的欠款数字
- `#notches` 十格进度：做成当票上的**打孔**或**朱砂点**，走过的、当前的、未到的三种状态要能一眼分辨
- 一枚红色印章做点睛（纯 CSS/SVG）

**招牌**（`.signboard h1`「幸运硬币」）
- 现在只是大字。做成**亮着的招牌**：暖光晕、可以有边框/挂绳/霓虹感，选一种并做透

**报幕条**（`.beat`）
- 结算时逐组报数的地方，是玩家视线焦点，值得单独设计
- `.beat.big`（大额）要明显比 `.beat.hot` 更隆重

### 色板起点（可调整，但要说明理由）
```
--ink       #0E0B08   底
--lacquer   #17120D   漆面
--brass     #C9A227   铜
--brass-lit #F0CB43   铜高光
--cinnabar  #C0402F   朱砂
--jade      #4E9E7F   玉青
--bone      #EDE3D2   骨白（机器上的字）
```
纸的颜色需要你自己定，现在没有。

---

## 4. 不要做的事

- 不要把所有圆角改成 `border-radius: 12px` 的现代卡片风，这游戏是漆器不是 SaaS
- 不要加渐变紫蓝、玻璃拟态、大面积模糊
- 不要用 emoji 当装饰性图标（符号本身是 emoji，那是内容，别再叠）
- 动效要克制：已有的滚轮、结算、拉杆已经够多了，**不要再加环境动画**
- 不要为了好看牺牲可读性：数字必须清楚，稀有度必须分得开

---

## 5. 验收清单

- [ ] 拉杆能拉，滚轮六列依次落定
- [ ] 结算时格子逐组点亮、飞钱、报幕条跳数
- [ ] 商店、符号池、道具册三个弹窗都正常
- [ ] 点道具/符号能弹出说明浮层，位置不出屏
- [ ] 关卡进度 `#notches` 十格状态正确
- [ ] 稀有度四色在盘面上能一眼分辨
- [ ] 窄屏不横向滚动
- [ ] 机器和账房是两种材质，不是同一种卡片
- [ ] 打开 DevTools 控制台**零报错、零外部请求失败**

---

## 6. 加分项

- 用 canvas 或 SVG feTurbulence 做纸纹/漆面颗粒（`data:` URI 内联）
- 铜的高光随光源方向一致（整页光从左上来）
- 为 `.cell` 的四种稀有度设计不同的**边框工艺**，而不只是换个颜色
