# Poker

A small Haskell command-line program that generates and prints a complete deck of playing cards: 52 regular cards plus 2 jokers.

## Current Features

- Prints all 52 regular cards, e.g. `Spade A`, `Heart 10`, `Club K`
- Prints 2 jokers: `RedJoker` and `BlackJoker`
- Encodes cards as products of prime numbers
- Compares two individual cards by rank and suit

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

Requires GHC and cabal.

```bash
cabal build
cabal run
```

Or explicitly:

```bash
cabal run Poker
```

## Project Structure

```text
Poker/
├── Poker.cabal           # Cabal project configuration
├── app/
│   └── Main.hs           # All source code
├── CHANGELOG.md
├── LICENSE
└── docs/
    └── README.zh-CN.md   # Chinese version of this README
```

## How It Works

### Card Model

A regular card is represented as:

```haskell
data Poker = Card CardType | Joker JokerType
```

where `CardType` is an integer encoding a card as the product of two prime numbers:

```haskell
cardValue = suitPrime * rankPrime
```

### Suit Encoding

The first 4 primes represent the 4 suits:

| Prime | Suit |
| --- | --- |
| 2 | Spade |
| 3 | Heart |
| 5 | Diamond |
| 7 | Club |

### Rank Encoding

The 13 primes starting from the 5th prime represent the 13 ranks:

| Prime | Rank |
| --- | --- |
| 11 | A |
| 13 | 2 |
| 17 | 3 |
| ... | ... |
| 47 | J |
| 53 | Q |
| 59 | K |

### Deck Generation

The deck is generated with a Cartesian product of suit primes and rank primes:

```haskell
listAllCard = (*) <$> colors <*> numbers
```

This creates 52 regular cards, and then two jokers are appended:

```haskell
listAllPoker = map Card listAllCard
            <> map Joker [RedJoker, BlackJoker]
```

### Card Parsing

When printing, each encoded card value is factored back into its two prime components:

- the first prime factor determines the suit;
- the second prime factor determines the rank.

### Card Comparison

Individual cards can be compared with `compareCard`:

```haskell
compareCard :: Poker -> Poker -> Ordering
compareCard = comparing (\c -> (rankOf c, suitOf c))
```

Comparison rules:

- `rankOf` maps `A` to 14, `J`/`Q`/`K` to 11/12/13, and number cards to their face value.
- Jokers are ranked above regular cards: `BlackJoker` = 99, `RedJoker` = 100.
- `suitOf` uses `Spade` = 0, `Heart` = 1, `Diamond` = 2, `Club` = 3.

## Implementation Notes

This project demonstrates:

- Custom algebraic data types
- Infinite prime list and lazy evaluation
- List Applicative / Cartesian products
- Encoding simple domain data using integer factorization

## Roadmap

Currently the program only prints the full deck; single-card comparison is available as internal functions. Possible next steps include:

- **Shuffle**: add randomness to shuffle the deck before printing
- **Deal**: deal cards round-robin to multiple players
- **Hand evaluation**: evaluate and compare complete five-card poker hands
