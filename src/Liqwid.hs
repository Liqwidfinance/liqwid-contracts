module Liqwid where

import qualified Data.Text                 as T
import           Language.Plutus.Contract  hiding (when)
import           Language.PlutusTx.Prelude

import Plutus.PAB.ContractCLI                     (commandLineApp)

hello :: Contract () BlockchainActions T.Text ()
hello =  logInfo @T.Text "Hello World"


contractCliMain :: IO ()
contractCliMain = commandLineApp hello
