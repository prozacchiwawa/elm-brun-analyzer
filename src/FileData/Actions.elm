module FileData.Actions exposing (runFile)

import File exposing (File)
import Json.Decode as JD
import Return exposing (Return)
import Return as Return
import Task as Task

import Bus as Bus
import FileData.Msg exposing (Msg (..))
import Model.Decode exposing (decodeFlags)

realizeFileData : File -> Cmd Bus.Msg
realizeFileData f = File.toString f |> Task.perform Bus.HaveFileData

runFile : Msg -> Return Bus.Msg model -> Return Bus.Msg model
runFile msg rm =
    case msg of
        FileUpload [] -> rm

        FileUpload (f :: _) -> rm |> Return.command (realizeFileData f)
