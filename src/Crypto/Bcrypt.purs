module Crypto.Bcrypt
  ( Hash(..)
  , hash
  , compare
  ) where

import Prelude (class Eq, class Show)
import Control.Monad.Aff (Aff)
import Control.Monad.Aff.Compat as Aff
import Data.Newtype (class Newtype, unwrap, wrap)
import Data.Functor (map)


newtype Hash =
  Hash String

derive instance newtypeHash :: Newtype Hash _
derive newtype instance showHash :: Show Hash
derive newtype instance eqHash :: Eq Hash


foreign import _hash
  :: forall eff
   . Int
  -> String
  -> Aff.EffFnAff eff String


foreign import _compare
  :: forall eff
   . String
  -> String
  -> Aff.EffFnAff eff Boolean


{-| Hash a password using the BCrypt algorithm and a given
number of rounds.

A salt is automatically generated.

See the documentation for the Javascript bcrypt.hash function
for more information.

https://www.npmjs.com/package/bcrypt#to-hash-a-password
-}
hash :: forall eff. Int -> String -> Aff eff Hash
hash saltRounds password = do
  map wrap
    (Aff.fromEffFnAff (_hash saltRounds password))



{-| Compare a password to a BCrypt password hash.

See the documentation for the Javascript bcrypt.compare function
for more information.

https://www.npmjs.com/package/bcrypt#to-check-a-password
-}
compare :: forall eff. Hash -> String -> Aff eff Boolean
compare hashed password =
  Aff.fromEffFnAff (_compare (unwrap hashed) password)
