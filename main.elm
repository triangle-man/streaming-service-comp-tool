import Html exposing (Html, Attribute, body, h1, p, button, div, input, text)
import Html.Attributes exposing (..)
import Html.App as App
import Html.Events exposing (onClick, onInput)

main =
    App.beginnerProgram { model = model, view = view, update = update }


-- MODEL

type alias Model =
    { movieTitle : String }   -- The title of the movie

model : Model
model = Model ""


-- UPDATE

type Msg = Change String | Search  

update : Msg -> Model -> Model
         
update msg model =
    case msg of
        Change newTitle ->
            { model | movieTitle = newTitle }
        Search ->
            model

-- VIEW

view : Model -> Html Msg
view model =
    body []
        [
          h1 [] [text "Streaming service comparison tool" ],
          p [] [text "Build a list of movies you want to watch and compare streaming services based on your list." ],
          div []
              [
                input [ placeholder "Enter a movie title", onInput Change ] [] ,
                button [ onClick Search ] [ text "Search" ]
              ]
        ]
        
