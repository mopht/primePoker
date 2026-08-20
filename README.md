# Poker

A small command-line program written in Haskell that generates and prints a full deck of playing cards (52 regular cards + 2 jokers).

## Features

When run, the program prints:

- 52 regular cards, e.g. `Spade A`, `Heart 10`, `Club K`
- 2 jokers: `RedJoker`, `BlackJoker`

Example output:

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

## Build & Run

You need GHC and cabal installed.

```bash
cabal build
cabal run
```

Or run explicitly:

```bash
cabal run Poker
```

## Project Structure

```text
Poker/
├── Poker.cabal       # Cabal project configuration
├── app/
│   └── Main.hs       # All source code
├── CHANGELOG.md
├── LICENSE
└── docs/
    └── README.zh-CN.md  # Chinese version of this README
```

## How It Works

A regular card is encoded as the product of two prime numbers:

```haskell
cardValue = suitPrime * rankPrime
```

- The first 4 primes `[2, 3, 5, 7]` represent the suits:

  | Prime | Suit |
  | --- | --- |
  | 2 | Spade |
  | 3 | Heart |
  | 5 | Diamond |
  | 7 | Club |

- The 13 primes starting from the 5th prime represent the ranks:

  | Prime | Rank |
  | --- | --- |
  | 11 | A |
  | 13 | 2 |
  | 17 | 3 |
  | ... | ... |
  | 47 | J |
  | 53 | Q |
  | 59 | K |

To build the full deck, it first takes the Cartesian product of suit primes and rank primes:

```haskell
listAllCard = (*) <$> colors <*> numbers
```

This produces 52 regular cards, then appends the two jokers:

```haskell
listAllPoker = map Card listAllCard
            <> map Joker [RedJoker, BlackJoker]
```

When printing, the program recovers the suit and rank by factoring the encoded card value.

## Notes

This project demonstrates some basic Haskell concepts:

- Custom algebraic data types
- Infinite prime list and lazy evaluation
- List Applicative / Cartesian products
- Encoding simple domain data using integer factorization

Currently it only prints a full deck. There is no shuffling, dealing, or hand evaluation yet.
