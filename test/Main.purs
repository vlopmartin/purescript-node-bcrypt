module Test.Main where

import Prelude
import Effect (Effect)
import Test.Unit (TestSuite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)
import Crypto.Bcrypt (Hash(..))
import Crypto.Bcrypt (hash, compare) as Bcrypt


main :: Effect Unit
main =
  runTest suites


suites :: TestSuite
suites = do
  test "Crypto.Bcrypt" do
    let password = "hunter7"
    hashed <- Bcrypt.hash 1 password

    Assert.expectFailure
      "password should not match hash"
      (Assert.equal (Hash password) hashed)

    shouldMatch <- Bcrypt.compare hashed password
    Assert.assert "password hashed can be checked" shouldMatch

    shouldntMatch <- Bcrypt.compare hashed "blink182"
    Assert.assertFalse "should not match other password" shouldntMatch
