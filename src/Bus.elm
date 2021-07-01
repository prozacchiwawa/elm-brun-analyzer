module Bus exposing (Msg (..))

import FileData.Msg as FD

type Msg
    = Noop
    | OpenHash String
    | CloseHash String
    | SetSearch String
    | Clear
    | HaveFileData String
    | Error String

    | FileAPI FD.Msg
