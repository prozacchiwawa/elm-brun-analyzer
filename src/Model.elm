module Model exposing (Model, HashOrigin, Flags, empty)

import Dict exposing (Dict)
import Dict as Dict
import Set exposing (Set)
import Set as Set

type alias HashOrigin =
    { result : String
    , arguments : List String
    }

type alias Flags =
    { hashes : Dict String HashOrigin
    }

type alias Model =
    { expanded : Set String
    , hashes : Flags
    , error : Maybe String
    , search : String
    }

empty : Model
empty =
    { expanded = Set.empty
    , hashes = { hashes = Dict.empty }
    , error = Nothing
    , search = ""
    }
