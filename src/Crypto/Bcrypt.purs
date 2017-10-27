module Crypto.Bcrypt
  ( hash
  , compare
  ) where

import Control.Monad.Aff (Aff)
import Control.Monad.Aff.Compat as Aff


type Hash =
  String


foreign import _hash
  :: forall eff
   . Int
  -> String
  -> Aff.EffFnAff eff Hash


foreign import _compare
  :: forall eff
   . Hash
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
hash saltRounds password =
  Aff.fromEffFnAff (_hash saltRounds password)


{-| Compare a password to a BCrypt password hash.

See the documentation for the Javascript bcrypt.compare function
for more information.

https://www.npmjs.com/package/bcrypt#to-check-a-password
-}
compare :: forall eff. Hash -> String -> Aff eff Boolean
compare hashed password =
  Aff.fromEffFnAff (_compare hashed password)
