import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as App
import Html.Events exposing (onClick, onInput)
import Dict
import Random.Pcg as Random -- A user-contributed RNG library
import Date
import Date.Format exposing (formatISO8601)
import Time

main =
    App.beginnerProgram { model = model, view = view, update = update }

-- ---------------------------------------------------------------------------------
-- The MODEL
-- Represents all data required to reproduce the page
   
type alias Model =
    { title   : String,                    -- Title of movie for search
      movies  : (List Movie, Random.Seed), -- Movies returned by search, and RNG stuff
      details : Dict.Dict Movie Details    -- Costs from each provider
    }
    
model : Model
model = Model "" ([], Random.initialSeed 29347983) Dict.empty

-- A movie is a pair, consisting of a name and a year of release
-- Really, it ought to be a record, as in
--     { title : String, yearOfRelease : Int}
-- but unfortunately Elm doesn't support the use of records as keys in Dicts. 
type alias Movie =               
     ( String, Int )             
                                 
moviename : Movie -> String
moviename = fst

movieyear : Movie -> Int
movieyear = snd
    
-- A ProviderCost is the streaming cost and the rental cost 
type alias ProviderCost =
    { streamCost : Float, rentCost : Float }

-- The Details are the ProviderCosts for each provider, plus a last updated time
type alias Details =
    { netflix : ProviderCost,     -- Yes, these should be in a list, but
      amazon : ProviderCost,      -- then I would have to figure out how to put
      hulu : ProviderCost,        -- them in a table 
      vudu : ProviderCost,  
      updated : Date.Date
    }

-- ---------------------------------------------------------------------------------
-- UPDATE
-- All the ways in which the web page may be updated

{- A Msg describes the action. The following actions are supported:
   . The user enters text in the search box 
   . The user clicks the "search" button 
   . The user adds a movie in the search results to the list of stored details
   . The user removes a movie from the list of stored details 
   . The user refreshes the details of a particular movie [not yet supported] 
-}

type Msg = Update String | Search | Add Movie | Remove Movie | Refresh Movie

update : Msg -> Model -> Model
update msg model =
    case msg of
        Update searchTerm ->
            { model |  title = searchTerm }  -- returns model with the title field updated
        Search ->
            { model | movies = findMovies model.title (snd model.movies) }
        Add movie ->
            { model | details = Dict.insert movie (getDetails movie) model.details }
        Remove movie ->
            { model | details = Dict.remove movie model.details }
        Refresh movie ->
            { model | details = Dict.insert movie (getDetails movie) model.details } 


-- Make up a random search result
-- Randomness is surprisingly tricky in a pure language!
findMovies : String -> Random.Seed -> (List Movie, Random.Seed) 
findMovies title seed =
    let
        gen =  Random.map3 (makeMovieList title) Random.bool (Random.int 1980 2016) (Random.int 0 3)
    in
        Random.step gen seed
    
-- Generate a movie and a list of sequels
makeMovieList : String -> Bool -> Int -> Int -> List Movie
makeMovieList title movieExistsP initialReleaseYear numSequels =
    if (not movieExistsP) then
        []
    else if (numSequels == 0) then
             [(title, initialReleaseYear)]
         else
             (title, initialReleaseYear) ::
                 List.map (\n -> (title ++ " " ++ toString (n+1), initialReleaseYear + 2 * n))
                     [1..numSequels]  

-- Make up the all the ProviderCosts of a particular movie
getDetails : Movie -> Details
getDetails movie =
    { netflix = { streamCost = 1.10, rentCost = 2.20 },
      amazon  = { streamCost = 1.20, rentCost = 2.40 },
      hulu    = { streamCost = 1.30, rentCost = 2.50 },
      vudu    = { streamCost = 1.40, rentCost = 2.70 },
      updated = Date.fromTime (1e9 * Time.second)
    }


-- ---------------------------------------------------------------------------------
-- VIEW
-- Generate HTML (or a representation thereof). There is no separate index.html
-- in Elm, although one is created during compilation 
-- Rather nicely, all of Elm is available to help construct the
-- HTML. Furthermore, the required actions are embedded.

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
                   tbody [ id "searchResultsTableBody" ]
                       (List.map searchResultsRow (fst model.movies))
                  ]],
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
                             td [] [text "Stream"],
                             td [] [text "Rent"],
                             td [] [text "Last updated"],
                             td [] [],
                             td [] [] ]],
                   tbody [ id "movieListTableBody" ]
                       (List.map movieDetailsRow (Dict.toList model.details))
                  ]],
             div [ class "footer" ] [
                  p [] [ text "Powered by ",
                         a [ href "http://canistream.it" ] [text "CanIStream.It"] ]]]
        
                                 
-- Make one row of the table of search results
searchResultsRow : Movie -> Html Msg
searchResultsRow movie =
    tr [] [
         td [] [ text (moviename movie)],
         td [] [ text (toString (movieyear movie)) ],
         td [] [ button [class "addButton", onClick (Add movie)] [text "Add"] ]]

-- Make one row of the table of costs
movieDetailsRow : (Movie, Details) -> Html Msg
movieDetailsRow (movie, details) =
    tr [] [
         td [] [ text (moviename movie) ], 
         td [] [ text (toString (movieyear movie)) ], 
         td [] [ text (toString details.netflix.streamCost)], 
         td [] [ text (toString details.netflix.rentCost)],
         td [] [ text (toString details.amazon.streamCost)], 
         td [] [ text (toString details.amazon.rentCost)],
         td [] [ text (toString details.hulu.streamCost)], 
         td [] [ text (toString details.hulu.rentCost)],
         td [] [ text (toString details.vudu.streamCost)], 
         td [] [ text (toString details.vudu.rentCost)],
         td [] [ text (formatISO8601 details.updated) ],
         td [] [ button [class "updateButton"] [text "Update"] ],
         td [] [ button [class "removeButton", onClick (Remove movie)] [text "Remove"] ]]
                         
        
