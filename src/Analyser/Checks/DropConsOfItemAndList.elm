module Analyser.Checks.DropConsOfItemAndList exposing (checker)

import ASTUtil.Inspector as Inspector exposing (Order(Post), defaultConfig)
import Analyser.Checks.Base exposing (Checker, keyBasedChecker)
import Analyser.Configuration exposing (Configuration)
import Analyser.FileContext exposing (FileContext)
import Analyser.Messages.Range as Range exposing (Range, RangeContext)
import Analyser.Messages.Types exposing (Message, MessageData(DropConsOfItemAndList), newMessage)
import Elm.Syntax.Expression exposing (..)


checker : Checker
checker =
    { check = scan
    , shouldCheck = keyBasedChecker [ "DropConsOfItemAndList" ]
    , key = "DropConsOfItemAndList"
    , name = "Drop Cons Of Item And List"
    , description = "If you cons an item to a literal list (x :x [1, 2, 3]), then you can just put the item into the list."
    }


type alias Context =
    List Range


scan : RangeContext -> FileContext -> Configuration -> List Message
scan rangeContext fileContext _ =
    Inspector.inspect
        { defaultConfig
            | onExpression = Post (onExpression rangeContext)
        }
        fileContext.ast
        []
        |> List.map (DropConsOfItemAndList fileContext.path)
        |> List.map (newMessage [ ( fileContext.sha1, fileContext.path ) ])


onExpression : RangeContext -> Expression -> Context -> Context
onExpression rangeContext ( r, inner ) context =
    case inner of
        OperatorApplication "::" _ _ ( _, ListExpr _ ) ->
            Range.build rangeContext r :: context

        _ ->
            context