# Poker

一个用 Haskell 编写的小型命令行程序：生成并打印一整副扑克牌（52 张普通牌 + 2 张王牌）。

## 功能

运行后会输出：

- 52 张普通牌，例如 `Spade A`、`Heart 10`、`Club K`
- 2 张王牌：`RedJoker`、`BlackJoker`

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
├── Poker.cabal       # Cabal 项目配置
├── app/
│   └── Main.hs       # 全部源码
├── CHANGELOG.md
├── LICENSE
└── docs/
    └── README.zh-CN.md  # 中文版 README
```

## 实现原理

普通扑克牌使用“两个素数的乘积”编码：

```haskell
cardValue = 花色对应素数 * 点数对应素数
```

- 前 4 个素数 `[2, 3, 5, 7]` 分别表示：

  | 素数 | 花色 |
  | --- | --- |
  | 2 | Spade |
  | 3 | Heart |
  | 5 | Diamond |
  | 7 | Club |

- 从第 5 个素数开始的 13 个素数表示点数：

  | 素数 | 点数 |
  | --- | --- |
  | 11 | A |
  | 13 | 2 |
  | 17 | 3 |
  | ... | ... |
  | 47 | J |
  | 53 | Q |
  | 59 | K |

生成整副牌时，先对花色素数和点数的素数做笛卡尔积：

```haskell
listAllCard = (*) <$> colors <*> numbers
```

得到 52 张普通牌后，再拼接两张王牌：

```haskell
listAllPoker = map Card listAllCard
            <> map Joker [RedJoker, BlackJoker]
```

输出时，通过素数分解还原出花色和点数。

## 说明

这个项目主要展示了 Haskell 的一些基础特性：

- 自定义代数数据类型
- 无限素数列表与惰性求值
- List Applicative / 笛卡尔积
- 用整数分解编码简单领域数据

目前只实现“打印整副牌”，没有洗牌、发牌、牌型比较等功能。
