module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing
    ( Html
    , a
    , audio
    , br
    , div
    , h1
    , h2
    , h3
    , img
    , li
    , nav
    , p
    , section
    , source
    , strong
    , text
    , ul
    )

import Html.Attributes exposing
    ( alt
    , controls
    , download
    , href
    , src
    , style
    , target
    , type_
    , rel
    )
import Url exposing (Url)


type Page
    = Home
    | Notes
    | Repertoire
    | Archive


type alias Model =
    { key : Nav.Key
    , page : Page
    }


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    ( { key = key, page = pageFromUrl url }, Cmd.none )


pageFromUrl : Url -> Page
pageFromUrl url =
    case url.fragment of
        Just "noter" ->
            Notes

        Just "repertoar" ->
            Repertoire

        Just "arkiv" ->
            Archive

        _ ->
            Home


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked (Browser.Internal url) ->
            ( model, Nav.pushUrl model.key (Url.toString url) )

        LinkClicked (Browser.External url) ->
            ( model, Nav.load url )

        UrlChanged url ->
            ( { model | page = pageFromUrl url }, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "Swinging Wheel Big Band"
    , body =
        [ navView
        , pageView model.page
        ]
    }


navView : Html Msg
navView =
    nav []
        [ a [ href "#" ] [ text "Start" ]
        , text " | "
        , a [ href "#noter" ] [ text "Noter" ]
        , text " | "
        , a [ href "#repertoar" ] [ text "Repertoar" ]
        , text " | "
        , a [ href "#arkiv" ] [ text "Arkiv" ]
        ]

eventCard : String -> String -> String -> String -> Html Msg
eventCard title date time location =
    section
        [ style "flex" "1"
        , style "min-width" "280px"
        , style "max-width" "420px"
        , style "padding" "28px"
        , style "background-color" "white"
        , style "border-radius" "12px"
        , style "box-shadow" "0 3px 12px rgba(0,0,0,0.08)"
        ]
        [ h2
            [ style "margin-top" "0"
            , style "color" "#d06d2c"
            ]
            [ text title ]
        , p [ style "font-weight" "bold" ] [ text date ]
        , p [] [ text time ]
        , p
            [ style "color" "#666"
            ]
            [ text location ]
        ]


pageView : Page -> Html Msg
pageView page =
    case page of
        Home ->
            homePage

        Notes ->
            noterPage

        Repertoire ->
            repertoarPage

        Archive ->
            divPage "Arkiv" "Här kan vi senare lägga låtar, bilder och videor."


divPage : String -> String -> Html Msg
divPage title description =
    div []
        [ h1 [] [ text title ]
        , p [] [ text description ]
        ]


audioTrack : String -> String -> String -> Maybe String -> Html Msg
audioTrack title filePath downloadName youtubeUrl =
    div
        [ style "margin-top" "24px"
        , style "padding" "16px"
        , style "background-color" "#f4f1ec"
        , style "border-radius" "8px"
        ]
        [ h3
            [ style "margin-top" "0" ]
            [ text title ]

        , case youtubeUrl of
            Just url ->
                p []
                    [ externalLink url "Lyssna på YouTube" ]

            Nothing ->
                text ""

        , audioPlayer filePath downloadName
        ]

externalLink : String -> String -> Html Msg
externalLink url label =
    a
        [ href url
        , target "noopener noreferrer"
        ]
        [ text label ]


audioPlayer : String -> String -> Html Msg
audioPlayer filePath downloadName =
    div []
        [ audio
            [ controls True ]
            [ source
                [ src filePath
                , type_ "audio/mpeg"
                ]
                []
            ]
        , p []
            [ a
                [ href filePath
                , download downloadName
                ]
                [ text "Ladda ner MP3" ]
            ]
        ]


homePage : Html Msg
homePage =
    div
        [ style "font-family" "Arial"
        , style "max-width" "1000px"
        , style "margin" "40px auto"
        , style "padding" "20px"
        ]
        [ h1 [] [ text "Swinging Wheel Big Band" ]

        , p []
            [ text "Swing, jazz och storbandsmusik." ]

        , section
            [ style "padding" "20px"
            , style "background-color" "#f4f1ec"
            , style "border-radius" "10px"
            ]
            [ h2 [] [ text "Välkommen!" ]
            , p []
                [ text "Här hittar du information om repetitioner, spelningar och vår repertoar." ]
            ]

        , section
            [ style "margin-top" "25px" ]
            [ h2 [] [ text "Kommande aktiviteter" ]

            , div
                [ style "display" "grid"
                , style "grid-template-columns" "repeat(auto-fit, minmax(260px, 1fr))"
                , style "gap" "16px"
                ]
                [ eventCard
                    "Repetition"
                    "Torsdag 24 september 2026"
                    "Kl. 19:00 – 21:15"
                    "Kulturskolan / Christinaskolan, Piteå"

                , eventCard
                    "Repetition"
                    "Lördag 10 oktober 2026"
                    "Kl. 10:00 – 14:00"
                    "Kulturskolan, Piteå"
                ]
            ]

        , section
            [ style "margin-top" "25px" ]
            [ h2 [] [ text "Alla aktiviteter" ]

            , p []
                [ text "Repetition – Torsdag 24 september 2026, kl. 19:00–21:15 (Kulturskolan / Christinaskolan, Piteå)" ]

            , p []
                [ text "Repetition – Lördag 10 oktober 2026, kl. 10:00–14:00 (Kulturskolan, Piteå)" ]

            , p []
                [ text "Genrep med Ida – Torsdag 15 oktober 2026, kl. 19:00–21:30 (Storstrand, Öjebyn)" ]

            , p []
                [ text "Spelning – Fredag 16 oktober 2026, kl. 19:00, samlingstid meddelas senare (Storstrand, Öjebyn)" ]
                  , externalLink "https://www.facebook.com/share/1HPRfbb4Gf/"
                  "Länk till Facebook-Event"

            , p []
                [ text "Spelning – Lördag 17 oktober 2026, kl. 13:00, samlingstid meddelas senare (Jazzklubben, Skellefteå)" ]
            ]
        ]

noterPage : Html Msg
noterPage =
    div
        [ style "font-family" "Arial"
        , style "max-width" "1000px"
        , style "margin" "40px auto"
        , style "padding" "20px"
        ]
        [ section
            [ style "margin-top" "25px" ]
            [ h2 [] [ text "Google Drive" ]

            , p []
                [ strong [] [ text "Noter" ]
                , br [] []
                , externalLink "https://drive.google.com/drive/folders/1e6CZIeFbtHq78eRMxCFlp2TrarGzmXal"
                "Länk till Google Drive"
            ]
        ]       
        ]
        
repertoarPage : Html Msg
repertoarPage =
    div
        [ style "font-family" "Arial"
        , style "max-width" "1000px"
        , style "margin" "40px auto"
        , style "padding" "20px"
        ]
        [ section
            []
            [ h1 [] [ text "Repertoar" ]

            , h2
                [ style "margin-top" "25px" ]
                [ text "Låtlista" ]

            , ul
                [ style "line-height" "1.35"
                , style "padding-left" "24px"
                , style "margin-top" "10px"
                ]
                [ li [] [ text "All Soul (version 2)" ]
                , li [] [ text "And So It Goes" ]
                , li [] [ text "Brutal Truth – Ida Sand" ]
                , li [] [ text "Cloudberry Jam" ]
                , li [] [ text "He Ain't Heavy" ]
                , li [] [ text "Higher Ground" ]
                , li [] [ text "Home (endast Ida)" ]
                , li [] [ text "I Wish I Knew (gamla versionen)" ]
                , li [] [ text "I'll Remember April" ]
                , li [] [ text "If You Don't Love Me" ]
                , li [] [ text "It's Your Woodoo" ]
                , li [] [ text "Other Body – John Brown" ]
                , li [] [ text "Joyband (blåsorkesterversion)" ]
                , li [] [ text "Love The One You're With" ]
                , li [] [ text "Piano" ]
                , li [] [ text "Who's Gonna Help Brother Get" ]
                ]

            , section
                [ style "margin-top" "35px"
                , style "padding-top" "20px"
                , style "border-top" "1px solid #ddd"
                ]
      
                [ h2 [] [ text "Spellista på Spotify" ]]
                , p
                    [ style "display" "flex"
                    , style "align-items" "center"
                    , style "gap" "12px"
                    ]
                    [ a
                        [ href "https://open.spotify.com/playlist/3bdfThx1BU2KijMaRYMvWa?si=TF5jTFFTRsOs3aiMN8J0mw"
                        , target "_blank"
                        , style "display" "inline-block"
                        , style "line-height" "0"
                        ]
                        [ img
                            [ src "media/spotifyikon.svg"
                            , alt "Spotify"
                            , style "width" "52px"
                            , style "height" "52px"
                            ]
                            []
                        ]
                     , text "Inte alla låtar och lite annorlund arr, men ändå"
                      ]

                , h3 [] [ text "MP3-filer" ]

                , audioTrack
                    "Brutal Truth – Ida Sand"
                    "audio/Brutal-Truth.mp3"
                    "Brutal Truth - Ida Sand.mp3"
                    (Just "https://www.youtube.com/watch?v=CTMSUvsfHuM")

                , audioTrack
                    "Cloudberry Jam"
                    "audio/Cloud-Berry-Jam.mp3"
                    "Cloudberry Jam.mp3"
                    Nothing

                , audioTrack
                    "I'll Remember April"
                    "audio/Ill-Remember-April.mp3"
                    "I'll Remember April.mp3"
                    Nothing

                , audioTrack
                    "Joyband – blåsorkesterversion"
                    "audio/Joyband.mp3"
                    "Joyband.mp3"
                    Nothing

                , audioTrack
                    "Love The One You're With"
                    "audio/Love-The-One.mp3"
                    "Love The One You're With.mp3"
                    Nothing
                ]
            ]
        
        

