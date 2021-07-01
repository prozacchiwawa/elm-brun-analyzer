module FileData.Msg exposing (Msg (..))

import File exposing (File)

type Msg
    = FileUpload (List File)
