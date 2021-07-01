module View exposing (view)

import Browser exposing (Document)
import Dict exposing (Dict)
import Dict as Dict
import Element exposing (Element, el, paragraph, text, column, html)
import Element.Background as BG
import Element.Input as EI
import File exposing (File)
import Framework exposing (responsiveLayout, container, layout)
import Framework.Color exposing (white, red)
import Framework.Card as Card
import Framework.Heading exposing (h3)
import Html exposing (div)
import Html.Attributes exposing (class, type_)
import Html.Events exposing (on)
import Json.Decode as JD

import Bus exposing (Msg (..))
import FileData.Msg as FDM
import Model exposing (Model, HashOrigin, Flags)
import View.Tree exposing (drawTree, makeViewTree)

elaborateHashes : Model -> Element Msg
elaborateHashes m = html <| drawTree m.expanded m.hashes.hashes m.search

filesDecoder : JD.Decoder (List File)
filesDecoder =
    JD.at ["target","files"] (JD.list File.decoder)

normalView : Model -> Document Msg
normalView model =
    { title = "CLVM Hash Tracing"
    , body =
        [ div [ class "fill" ]
              [ responsiveLayout [] <|
                    el container <|
                      el (Card.fill ++ [BG.color white]) <|
                          el container <|
                              (column []
                                   [ paragraph h3
                                         [ text "CLVM Hash Tracer" ]
                                   , if Dict.size model.hashes.hashes > 0 then
                                         EI.text []
                                             { onChange = SetSearch
                                             , text = model.search
                                             , placeholder = Just (EI.placeholder [] (text "94af93ec..."))
                                             , label = EI.labelLeft [] (text "Search for hash")
                                             }
                                     else
                                         Element.html
                                             (Html.input
                                                  [ type_ "file"
                                                  , on "change"
                                                      (JD.map (FileAPI << FDM.FileUpload) filesDecoder)
                                                  ] []
                                             )
                                   , elaborateHashes model
                                   ]
                              )
              ]
        ]
    }

errorView : String -> Document Msg
errorView e =
    { title = "CLVM Hash Tracing (error " ++ e ++ ")"
    , body =
        [ div [ class "fill" ]
              [ responsiveLayout [] <|
                    el container <|
                      el (Card.fill ++ [BG.color red]) <|
                        (paragraph []
                             [ text e
                             ]
                        )
              ]
        ]
    }

view : Model -> Document Msg
view model =
    case model.error of
        Nothing -> normalView model
        Just e -> errorView e
