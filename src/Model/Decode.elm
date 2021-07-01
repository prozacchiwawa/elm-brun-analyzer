module Model.Decode exposing (decodeFlags)

import Json.Decode as JD

import Dict exposing (Dict)
import Dict as Dict
import Model exposing (HashOrigin, Flags)

decodeFlags : JD.Decoder Flags
decodeFlags =
    (JD.field "hashes"
         (JD.dict (JD.list JD.string)
         |> JD.map (Dict.map (\k v -> { result = k, arguments = v }))
         |> JD.map Flags
         )
    )
