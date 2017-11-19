module Analyser.Checks.DropConsOfItemAndList exposing (checker)

import ASTUtil.Inspector as Inspector exposing (Order(Post), defaultConfig)
import Analyser.Checks.Base exposing (Checker)
import Analyser.Configuration exposing (Configuration)
import Analyser.FileContext exposing (FileContext)
import Analyser.Messages.Data as Data exposing (MessageData)
import Analyser.Messages.Range as Range exposing (RangeContext)
import Analyser.Messages.Schema as Schema
import Elm.Syntax.Expression exposing (..)


checker : Checker
checker =
    { check = scan
    , info =
        { key = "DropConsOfItemAndList"
        , name = "Drop Cons Of Item And List"
        , description = "If you cons an item to a literal list (x :x [1, 2, 3]), then you can just put the item into the list."
        , schema =
            Schema.schema
                |> Schema.rangeProp "range"
        }
    }


type alias Context =
    List MessageData


scan : RangeContext -> FileContext -> Configuration -> List MessageData
scan rangeContext fileContext _ =
    Inspector.inspect
        { defaultConfig
            | onExpression = Post (onExpression rangeContext)
        }
        fileContext.ast
        []


onExpression : RangeContext -> Expression -> Context -> Context
onExpression rangeContext ( r, inner ) context =
    case inner of
        OperatorApplication "::" _ _ ( _, ListExpr _ ) ->
            let
                range =
                    Range.build rangeContext r
            in
            (Data.init
                (String.concat
                    [ "Adding an item to the front of a literal list, but instead you can just put it in the list. At "
                    , Range.asString range
                    ]
                )
                |> Data.addRange "range" range
            )
                :: context

        _ ->
            context
