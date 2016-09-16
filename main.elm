import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as App
import Html.Events exposing (onClick, onInput)
import Dict
import Random.PCG as Random -- A user-contributed RNG library

main =
    App.beginnerProgram { model = model, view = view, update = update }


-- MODEL

-- Type for representing a movies

type alias Movie =                -- (movie title, year of relase). Ought to be a
     ( String, Int )              -- record, but Elm does not support records as
                                  -- the keys in a Dict.
moviename : Movie -> String
moviename = fst

movieyear : Movie -> Int
movieyear = snd
    
-- Types for representing the details of costs for movies

type alias ProviderCost =
    { streamCost : Float, rentCost : Float }
    
type alias Details =
    { netflix : ProviderCost,     -- Yes, these should be in a list, but
      amazon : ProviderCost,      -- then I would have to figure out how to put
      hulu : ProviderCost,        -- them in a table 
      vudu : ProviderCost,  
      updated : Date
    }

-- Type for representing all data on the webpage

type alias Model =
    { title   : String,                   -- Title of movie for search
      movies  : List Movie                -- Movies returned by search
      details : Dict Movie Details        -- Costs from each provider
    }
    
model : Model
model = Model "" [] Dict.empty 


-- UPDATE

{- The following actions are supported:
   . The user enters text in the search box 
   . The user clicks the "search" button 
   . The user adds a movie in the search results to the list of stored details
   . The user removes a movie from the list of stored details 
   . The user refreshes the details of a particular movie 
-}

type Msg = Update String | Search | Add Movie | Remove Movie | Update Movie

update : Msg -> Model -> Model
update msg model =
    case msg of
        Update seachTerm ->
            { model |  title = searchTerm }  -- This is how you do record
                                                -- update in Elm
        Search ->
            { model | movies = findMovies model.title}
        Add movie ->
            { model | details = Dict.insert movie (getDetails movie) model.details }
        Remove movie ->
            { model | details = Dict.remove movie model.details }
        Update movie ->
            { model | details = Dict.insert movie (getDetails movie) model.details } 

-- At present, findMovies just makes up a random list    
findMovies : String -> List Movie
findMovies title =
    if []
    



-- VIEW
   
-- The function view produces HTML (or a representation thereof). There is no
-- separate index.html file.

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
        
                                 

                                 

                                 
                         
        
