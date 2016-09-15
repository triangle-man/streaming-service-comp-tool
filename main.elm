import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as App
import Html.Events exposing (onClick, onInput)

main =
    App.beginnerProgram { model = model, view = view, update = update }


-- MODEL

type alias Movie =
    { movieTitle : String, releaseYear: Int }

type alias Model =
    { movieTitle : String,             -- The title of the movie
      movieList : List Movie           -- Movies looked up by title
    }
    
model : Model
model = Model "" []


-- UPDATE

type Msg = Update String | Search  

update : Msg -> Model -> Model
         
update msg model =
    case msg of
        Update newTitle ->
            { model |                                 -- This is record update in Elm
                  movieTitle = newTitle,
                  movieList = findMovies newTitle 
            }
        Search ->
            model

findMovies : String -> List Movie
findMovies title =
    []
    



-- VIEW

view : Model -> Html Msg
view model =
    body [] [
         div [ class "header" ] [
              h1 [] [text "Streaming service comparison tool" ],
              p [] [text "Build a list of movies you want to watch and compare streaming services based on your list." ]],
         div [ class "input-section" ] [
              input [ placeholder "Enter a movie title", id "searchBox", onInput Update ] [],
              button [ class "searchButton", onClick Search ] [ text "Search" ]],
         div [ class "search-results-section" ] [
              h3 [] [text "Search results"],
              table [] [
                   thead [] [
                        td [] [text "Title"],
                        td [] [text "Release year"],
                        td [] [] ],
                   tbody [ id "searchResultsTableBody" ] [
                        tr [] [
                             td [colspan 2] [ em [] [text "None"] ],
                             td [] [ button [ class "addButton" ] [text "Add"] ]]]]],
         div [ class "movie-list-section" ] [
              h3 [] [text "Movie list"],
              table [] [
                   thead [] [
                        tr [] [
                             td [] [],
                             td [] [],
                             td [colspan 2] [text "Netflix"],
                             td [colspan 2] [text "Amazon"],
                             td [colspan 2] [text "Hulu"],
                             td [colspan 2] [text "Vudu"],
                             td [] [],
                             td [] [],
                             td [] [] ],
                        tr [] [
                             td [] [text "Title"],
                             td [] [text "Release year"],
                             td [] [text "Stream"],
                             td [] [text "Rent"],
                             td [] [text "Stream"],
                             td [] [text "Rent"],
                             td [] [text "Stream"],
                             td [] [text "Rent"],
                             td [] [text "Last updated"],
                             td [] [],
                             td [] [] ]],
                   tbody [ id "movieListTableBody" ] [
                        tr [] [
                             td [colspan 11] [ em [] [text "None"] ],
                             td [] [ button [class "updateButton"] [text "Update"] ],
                             td [] [ button [class "removeButton"] [text "Remove"] ]]]]],
             div [ class "footer" ] [
                  p [] [ text "Powered by ",
                         a [ href "http://canistream.it" ] [text "CanIStream.It"] ]]]
        
                                 

                                 

                                 
                         
        
