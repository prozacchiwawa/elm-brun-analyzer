module View.Tree exposing (..)

import BigInt exposing (BigInt)
import BigInt as BigInt
import Debug exposing (..)
import Dict exposing (Dict)
import Dict as Dict
import List.Extra as LX
import Set exposing (Set)
import Set as Set
import String as String
import Hex as Hex
import Html exposing (Html, div, text, pre)
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick)

import Bus exposing (Msg (..))
import Codepage.Codepage437 exposing (cp437)
import Model

type NodeState
    = Unmatched
    | Open
    | Closed

type Node = TreeNode
    { state : NodeState
    , title : String
    , children : List Node
    }

makeTreeNode opened d root =
    let
        childNodes e =
            if Set.member e.result opened then
               (e.arguments
               |> List.map (makeTreeNode opened d)
               )
            else
                []
    in
    case Dict.get root d of
        Just e ->
            TreeNode
                { state = if Set.member e.result opened then Open else Closed
                , title = e.result
                , children = childNodes e
                }
        Nothing ->
            TreeNode
                { state = Unmatched
                , title = root
                , children = []
                }

makeViewTree opened d search =
    let
        allHashes =
            Dict.keys d |> Set.fromList |> Set.filter (\u -> String.startsWith search u)

        allIncoming =
            Dict.foldl
                (\k v s_ ->
                     List.foldl
                     (\u s ->
                          if search /= "" && String.startsWith search u then
                              s
                          else
                              Set.insert u s
                     )
                     s_
                     v.arguments
                )
                Set.empty
                d

        unusedHashes =
            Set.diff allHashes allIncoming
    in
    TreeNode
        { state = Open
        , title = "Collected from run:"
        , children =
            Set.toList unusedHashes
        |> List.map (makeTreeNode opened d)
        }

drawNode : Bool -> Node -> Html Msg
drawNode marker (TreeNode n) =
    let
        color =
            case n.state of
                Unmatched -> "#dd0"
                Open -> "#000"
                Closed -> "#ddd"

        clickmsg =
            case n.state of
                Unmatched -> Noop
                Open -> CloseHash n.title
                Closed -> OpenHash n.title

        openOrClosedClass =
            case n.state of
                Unmatched -> "node-leaf"
                Open -> "node-open"
                Closed -> "node-closed"

        showIntegerValue v =
            case BigInt.fromHexString v of
                Just bi ->
                    div [class "node-detail"]
                        [ div [class "node-detail-label"] [text "decimal"]
                        , div [class "node-detail-value"] [text <| BigInt.toString bi]
                        ]

                Nothing -> div [] []

        showStringValue v =
            let
                str =
                    String.toList v
                    |> LX.groupsOf 2
                    |> List.map
                       (\g ->
                            case Hex.fromString (String.fromList g) of
                                Ok 0 -> "."
                                Ok ch -> String.slice ch (ch + 1) cp437
                                _ -> "?"
                       )
                    |> LX.greedyGroupsOf 32
                    |> List.map (\l -> String.concat (l ++ ["\n"]))
                    |> String.concat
            in
            div [class "node-detail"]
                [ div [class "node-detail-label"] [text "string"]
                , div [class "node-detail-value"] [pre [] [text str]]
                ]

        details =
            if marker then
                [ div [class "node-detail"]
                      [ div [class "node-detail-label"] [text "hex-repr"]
                      , div [class "node-detail-value"] [text n.title]
                      ]
                , showIntegerValue n.title
                , showStringValue n.title
                ]
            else
                [text n.title]

    in
    div [ class "node" ]
        [ div [ class "node-headline-row", onClick clickmsg ]
              [ div [ classList [(openOrClosedClass,marker)] ] []
              , div
                [ class "node-heading" ] (details)
              ]
        , div [ class "node-container" ]
            (List.map (drawNode True) n.children)
        ]

drawTree opened d search = drawNode False (makeViewTree opened d search)
