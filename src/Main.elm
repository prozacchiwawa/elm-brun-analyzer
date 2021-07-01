module Main exposing (main)

import Browser
import Browser.Navigation exposing (Key)
import Dict exposing (Dict)
import Dict as Dict
import Json.Decode as JD
import Return
import Set exposing (Set)
import Set as Set
import Url exposing (Url)

import Bus exposing (Msg (..))
import FileData.Actions exposing (runFile)
import Model exposing (Model, Flags, empty)
import Model.Decode exposing (decodeFlags)
import View exposing (view)

updateModelWithFlagData : Result JD.Error Flags -> Model -> Model
updateModelWithFlagData decodeResult model =
    case decodeResult of
        Ok f ->
            { model | hashes = f, error = Nothing }

        Err e ->
            { model | hashes = Flags Dict.empty, error = Just (JD.errorToString e) }

init : JD.Value -> Url -> Key -> (Model, Cmd Msg)
init v u k =
    empty
    |> updateModelWithFlagData (JD.decodeValue decodeFlags v)
    |> Return.singleton

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Noop -> Return.singleton model
        SetSearch s ->
            Return.singleton
                { model
                | search = s
                }
        OpenHash h ->
            Return.singleton
                { model
                | expanded = Set.insert h model.expanded
                }

        CloseHash h ->
            Return.singleton
                { model
                | expanded = Set.remove h model.expanded
                }

        Error e ->
            Return.singleton
                { model
                | error = Just e
                }

        Clear -> Return.singleton empty

        HaveFileData s ->
            model
            |> updateModelWithFlagData (JD.decodeString decodeFlags s)
            |> Return.singleton

        FileAPI fmsg ->
            Return.singleton model |> runFile fmsg

main : Program JD.Value Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlChange = \_ -> Noop
        , onUrlRequest = \_ -> Noop
        }

