module Crypto.Bcrypt
  ( Hash(..)
  , hash
  , compare
  ) where

import Prelude (class Eq, class Show)
import Effect.Aff (Aff)
import Effect.Aff.Compat as Aff
import Data.Newtype (class Newtype, unwrap, wrap)
import Data.Functor (map)


newtype Hash =
  Hash String

derive instance newtypeHash :: Newtype Hash _
derive newtype instance showHash :: Show Hash
derive newtype instance eqHash :: Eq Hash


foreign import _hash
  :: Int
  -> String
  -> Aff.EffectFnAff String


foreign import _compare
  :: String
  -> String
  -> Aff.EffectFnAff Boolean


{-| Hash a password using the BCrypt algorithm and a given
number of rounds.

A salt is automatically generated.

See the documentation for the Javascript bcrypt.hash function
for more information.

https://www.npmjs.com/package/bcrypt#to-hash-a-password
-}
hash :: Int -> String -> Aff Hash
hash saltRounds password = do
  map wrap
    (Aff.fromEffectFnAff (_hash saltRounds password))



{-| Compare a password to a BCrypt password hash.

See the documentation for the Javascript bcrypt.compare function
for more information.

https://www.npmjs.com/package/bcrypt#to-check-a-password
-}
compare :: Hash -> String -> Aff Boolean
compare hashed password =
  Aff.fromEffectFnAff (_compare (unwrap hashed) password)
