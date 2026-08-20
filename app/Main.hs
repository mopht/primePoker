{-# OPTIONS_GHC -Wno-incomplete-uni-patterns #-}
module Main where

import Data.List (elemIndex, genericIndex)

data Poker     = Card CardType | Joker JokerType
data JokerType = RedJoker | BlackJoker
    deriving Show

type CardType = Integer
type Color    = Integer
type Number   = Integer

main :: IO ()
main = putStr . unlines . map parsePoker $ listAllPoker

listAllPoker :: [Poker]
listAllPoker = map Card listAllCard
            <> map Joker [RedJoker, BlackJoker]

listAllCard :: [CardType]
listAllCard = (*) <$> colors <*> numbers
  where numbers = take 13 . drop colorCnt $ primes
        colors = take colorCnt primes

num :: Int -> Number
num = genericIndex primes . (+ fstIndex)

parsePoker :: Poker -> String
parsePoker (Joker n) = show n
parsePoker (Card n)  = parseCard n

parseCard :: CardType -> String
parseCard = liftA2 (<>) parseCardColor parseCardNumber

parseCardColor :: CardType -> String
parseCardColor n = case fmap fst (factor n) of
    Just p | p == spades   -> "Spade "
           | p == hearts   -> "Heart "
           | p == diamonds -> "Diamond "
           | p == clubs    -> "Club "
    _                      -> ""

parseCardNumber :: CardType -> String
parseCardNumber n = case fmap snd $ factor n of
    Just numPrime -> showCard $ switch numPrime
    Nothing       -> ""
  where switch = (-toInteger fstIndex +) . primeIndex

showCard :: CardType -> String
showCard 1  = "A"
showCard 11 = "J"
showCard 12 = "Q"
showCard 13 = "K"
showCard n  = show n

colorCnt, fstIndex :: Int
colorCnt = 4
fstIndex = colorCnt - 1

spades, hearts, diamonds, clubs :: Color
[spades, hearts, diamonds, clubs] = take colorCnt primes

primes :: [Integer]
primes = sieve [2..]
  where
    sieve (p:xs) = p : sieve [x | x <- xs, mod x p /= 0]
    sieve []     = []

primeIndex :: Integer -> Integer
primeIndex p = case elemIndex p primes of
    Just n  -> toInteger n
    Nothing -> error "not a prime"

factor :: Integer -> Maybe (Color, Number)
factor n =
  case [(p, div n p) | p <- primes, mod n p == 0] of
    (x:_) -> Just x
    []    -> Nothing
