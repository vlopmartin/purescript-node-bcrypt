module Test.Main where

import Prelude (Unit, bind, discard)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.AVar (AVAR)
import Control.Monad.Eff.Console (CONSOLE)
import Test.Unit (TestSuite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Console (TESTOUTPUT)
import Test.Unit.Main (runTest)

import Crypto.Bcrypt


main :: forall e
  . Eff ( console :: CONSOLE
        , testOutput :: TESTOUTPUT
        , avar :: AVAR
        | e
        ) Unit
main =
  runTest suites


suites :: forall e. TestSuite e
suites = do
  test "Crypo.BCrypt" do
    let password = "hunter7"
    hashed <- hash 1 password

    Assert.expectFailure
      "password should not match hash"
      (Assert.equal password hashed)

    shouldMatch <- compare hashed password
    Assert.assert "password hashed can be checked" shouldMatch

    shouldntMatch <- compare hashed "blink182"
    Assert.assertFalse "should not match other password" shouldntMatch
