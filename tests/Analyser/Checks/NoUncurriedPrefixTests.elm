module Analyser.Checks.NoUncurriedPrefixTests exposing (..)

import Analyser.Checks.CheckTestUtil as CTU
import Analyser.Checks.NoUncurriedPrefix as NoUncurriedPrefix
import Analyser.Messages.Data as Data exposing (MessageData)
import Test exposing (Test)


prefixAsApplicationWithTwoArgs : ( String, String, List MessageData )
prefixAsApplicationWithTwoArgs =
    ( "prefixAsApplicationWithTwoArgs"
    , """module Foo exposing (..)

foo = (+) 1 2
"""
    , [ Data.init "foo"
            |> Data.addVarName "varName" "+"
            |> Data.addRange "range"
                { start = { row = 2, column = 6 }, end = { row = 2, column = 9 } }
      ]
    )


prefixAsApplicationWithOneArg : ( String, String, List MessageData )
prefixAsApplicationWithOneArg =
    ( "prefixAsApplicationWithOneArg"
    , """module Foo exposing (..)


foo = (+) 1

"""
    , []
    )


all : Test
all =
    CTU.build "Analyser.Checks.NoUncurriedPrefix"
        NoUncurriedPrefix.checker
        [ prefixAsApplicationWithTwoArgs
        , prefixAsApplicationWithOneArg
        ]
