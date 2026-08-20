# Poker

一个用 Haskell 编写的小型命令行程序：生成并打印一整副扑克牌，包括 52 张普通牌和 2 张王牌。

## 当前功能

- 打印全部 52 张普通牌，例如 `Spade A`、`Heart 10`、`Club K`
- 打印 2 张王牌：`RedJoker`、`BlackJoker`
- 使用“两个素数的乘积”编码扑克牌
- 支持比较两张单牌的大小

示例输出：

```text
Spade A
Spade 2
Spade 3
...
Club Q
Club K
RedJoker
BlackJoker
```

## 构建与运行

需要安装 GHC 和 cabal。

```bash
cabal build
cabal run
```

或者直接运行：

```bash
cabal run Poker
```

## 项目结构

```text
Poker/
├── Poker.cabal           # Cabal 项目配置
├── app/
│   └── Main.hs           # 全部源码
├── CHANGELOG.md
├── LICENSE
└── docs/
    └── README.zh-CN.md   # 中文版 README
```

## 实现原理

### 牌的数据模型

普通牌定义为：

```haskell
data Poker = Card CardType | Joker JokerType
```

其中 `CardType` 是一个整数，表示“花色对应素数 × 点数对应素数”：

```haskell
cardValue = 花色对应素数 * 点数对应素数
```

### 花色编码

前 4 个素数表示 4 种花色：

| 素数 | 花色 |
| --- | --- |
| 2 | Spade |
| 3 | Heart |
| 5 | Diamond |
| 7 | Club |

### 点数编码

从第 5 个素数开始的 13 个素数表示 13 个点数：

| 素数 | 点数 |
| --- | --- |
| 11 | A |
| 13 | 2 |
| 17 | 3 |
| ... | ... |
| 47 | J |
| 53 | Q |
| 59 | K |

### 生成整副牌

先用花色素数和点数的素数做笛卡尔积：

```haskell
listAllCard = (*) <$> colors <*> numbers
```

得到 52 张普通牌后，再拼接两张王牌：

```haskell
listAllPoker = map Card listAllCard
            <> map Joker [RedJoker, BlackJoker]
```

### 解析输出

打印时，通过素数分解还原每张牌：

- 第一个素因子决定花色；
- 第二个素因子决定点数。

### 单牌比较

可以使用 `compareCard` 比较两张单牌：

```haskell
compareCard :: Poker -> Poker -> Ordering
compareCard = comparing (\c -> (rankOf c, suitOf c))
```

比较规则：

- `rankOf` 把 `A` 映射为 14，`J`/`Q`/`K` 映射为 11/12/13，数字牌使用面值。
- 王牌大于普通牌：`BlackJoker` = 99，`RedJoker` = 100。
- `suitOf` 使用 `Spade` = 0，`Heart` = 1，`Diamond` = 2，`Club` = 3。

## 实现说明

这个项目主要展示了：

- 自定义代数数据类型
- 无限素数列表与惰性求值
- List Applicative / 笛卡尔积
- 用整数分解编码简单领域数据

## 后续计划

目前程序的主流程仍然只是“打印整副牌”，单牌比较已作为内部函数提供。可能的下一步包括：

- **洗牌**：加入随机性，输出前先打乱牌堆
- **发牌**：按玩家数量轮流发牌
- **手牌评估**：评估并比较完整的五张牌牌型大小
