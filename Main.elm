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
      [ div
        [ style "font-family" "Arial"
        , style "font-size" "20px"
        , style "line-height" "1.5"
        ]
        [ navView model.page
        , pageView model.page
        ]
      ]
    }

navView : Page -> Html Msg
navView currentPage =
    nav
        [ style "font-family" "Arial"
        , style "display" "flex"
        , style "justify-content" "center"
        , style "gap" "8px"
        , style "padding" "20px 10px"
        , style "background-color" "#f4f1ec"
        , style "flex-wrap" "wrap"
        ]

        [ navLink currentPage Home "#" "Start"
        , navLink currentPage Notes "#noter" "Noter"
        , navLink currentPage Repertoire "#repertoar" "Repertoar"
        , navLink currentPage Archive "#arkiv" "Arkiv"
        ]

navLink : Page -> Page -> String -> String -> Html Msg
navLink currentPage page url label =
    a
        [ href url
        , style "padding" "18px 26px"
        , style "border-radius" "10px"
        , style "text-decoration" "none"
        , style "font-size" "21px"
        , style "font-weight" "bold"
        , style "color"
            (if currentPage == page then
                "white"
             else
                "#444"
            )
        , style "background-color"
            (if currentPage == page then
                "#d06d2c"
             else
                "transparent"
            )
        ]
        [ text label ]


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
            arkivPage

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
        , style "font-size" "22px"
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

archiveCard : String -> String -> String -> Html Msg
archiveCard icon title description =
    section
        [ style "padding" "28px"
        , style "background-color" "#f4f1ec"
        , style "border-radius" "12px"
        , style "text-align" "center"
        , style "box-shadow" "0 3px 12px rgba(0,0,0,0.08)"
        ]
        [ div
            [ style "font-size" "40px" ]
            [ text icon ]

        , h2
            [ style "margin-bottom" "10px"
            , style "color" "#d06d2c"
            ]
            [ text title ]

        , p
            [ style "color" "#666"
            , style "font-size" "17px"
            ]
            [ text description ]
        ]

activity : String -> String -> String -> String -> Html Msg
activity title date time location =
    div
        [ style "margin-bottom" "24px"
        , style "padding-bottom" "20px"
        , style "border-bottom" "1px solid #ddd"
        ]
        [ h3
            [ style "margin-bottom" "6px"
            , style "color" "#d06d2c"
            ]
            [ text title ]

        , p
            [ style "font-weight" "bold"
            , style "margin" "4px 0"
            ]
            [ text date ]

        , p
            [ style "margin" "4px 0"
            ]
            [ text time ]

        , p
            [ style "color" "#666"
            , style "margin" "4px 0"
            ]
            [ text ("📍 " ++ location) ]
        ]

divPage : String -> String -> Html Msg
divPage title description =
    div []
        [ h1 [] [ text title ]
        , p [] [ text description ]
        ]



externalLink : String -> String -> Html Msg
externalLink url label =
    a
        [ href url
        , target "noopener noreferrer"
        ]
        [ text label ]

youtubeLink : String -> Html Msg
youtubeLink url =
    a
        [ href url
        , target "_blank"
        , rel "noopener noreferrer"
        , style "display" "inline-block"
        , style "padding" "10px 16px"
        , style "background-color" "#cc3333"
        , style "color" "white"
        , style "text-decoration" "none"
        , style "border-radius" "6px"
        , style "font-weight" "bold"
        ]
        [ text "▶ YouTube" ]

facebookLink : String -> Html Msg
facebookLink url =
    a
        [ href url
        , target "_blank"
        , rel "noopener noreferrer"
        , style "display" "inline-block"
        , style "padding" "10px 16px"
        , style "background-color" "#4267B2"
        , style "color" "white"
        , style "text-decoration" "none"
        , style "border-radius" "6px"
        , style "font-weight" "bold"
        ]
        [ text "f  Facebook-event" ]

audioPlayer : String -> String -> Maybe String -> Html Msg
audioPlayer filePath downloadName youtubeUrl =
    div []
        [ audio
            [ controls True
            , style "width" "50%"
            , style "height" "60px"
            ]
            [ source
                [ src filePath
                , type_ "audio/mpeg"
                ]
                []
            ]

        , case youtubeUrl of
            Just url ->
                p
                    [ style "margin" "12px 0" ]
                    [ youtubeLink url ]

            Nothing ->
                text ""

        , p
            [ style "margin-top" "12px" ]
            [ a
                [ href filePath
                , download downloadName
                , style "display" "inline-block"
                , style "padding" "10px 16px"
                , style "background-color" "#666"
                , style "color" "white"
                , style "text-decoration" "none"
                , style "border-radius" "6px"
                , style "font-weight" "bold"
                ]
                [ text "↓ Ladda ner MP3" ]
            ]
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
        , audioPlayer filePath downloadName youtubeUrl
        ]




------- pages ------

homePage : Html Msg
homePage =
    div
        [ style "font-family" "Arial"
        , style "max-width" "1000px"
        , style "margin" "40px auto"
        , style "padding" "20px"
        ]
        [ h1 [] [ text "Swinging Wheel Big Band" ]

        , section
            [ style "padding" "20px"
            , style "background-color" "#f4f1ec"
            , style "border-radius" "10px"
            ]
            [ h2 [] [ text "Välkommen!" ]
            , p []
                [ text "Här hittar du information om repetitioner, spelningar och vår repertoar."
                , br [] []
                , br [] []
                , strong [] [ text "HOME! Ida Sand och SWBB" ]
                , br [] []
                , text "Fredag 16 oktober 2026 19:00"
                , br [] []
                , br [] []
                , facebookLink "https://www.facebook.com/share/1HPRfbb4Gf/"
                ]

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
        
            , activity
                "Repetition"
                "Torsdag 24 september 2026"
                "19:00–21:15"
                "Kulturskolan / Christinaskolan, Piteå"
        
            , activity
                "Repetition"
                "Lördag 10 oktober 2026"
                "10:00–14:00"
                "Kulturskolan, Piteå"
        
            , activity
                "Genrep med Ida"
                "Torsdag 15 oktober 2026"
                "19:00–21:30"
                "Storstrand, Öjebyn"
    
        
            , activity
                "Spelning"
                "Fredag 16 oktober 2026"
                "19:00 – samlingstid meddelas senare"
                "Storstrand, Öjebyn"

            , activity
                "Spelning"
                "Lördag 17 oktober 2026"
                "13:00 – samlingstid meddelas senare"
                "Jazzklubben, Skellefteå"
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
        [ h1
            [ style "color" "#d06d2c" ]
            [ text "🎼 Noter" ]

        , p
            [ style "font-size" "19px"
            , style "line-height" "1.5"
            ]
            [ text "Här hittar du våra noter och annat material inför repetitioner och spelningar." ]

        , section
            [ style "margin-top" "30px"
            , style "padding" "28px"
            , style "background-color" "#f4f1ec"
            , style "border-radius" "12px"
            , style "box-shadow" "0 3px 12px rgba(0,0,0,0.08)"
            ]
            [ h2
                [ style "margin-top" "0" ]
                [ text "📁 Notbibliotek" ]

            , p []
                [ text "Alla noter finns samlade i vårt Google Drive-arkiv." ]

            , externalLink
                "https://drive.google.com/drive/folders/1e6CZIeFbtHq78eRMxCFlp2TrarGzmXal"
                "Öppna Google Drive"
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
            [ h1 [] [ text "HOME! Ida Sand & SWBB" ]

            , h2
                [ style "margin-top" "25px" ]
                [ text "Set-list" ]

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
                , li [] [ text "Joyband" ]
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
                            , style "width" "100px"
                            , style "height" "100px"
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
                    "I'll Remember April (öva denna!)"
                    "audio/Ill-Remember-April.mp3"
                    "I'll Remember April.mp3"
                    Nothing

                , audioTrack
                    "Joyband – blåsorkesterversion"
                    "audio/Joyband.mp3"
                    "Joyband (blåsorkester).mp3"
                    Nothing

                , audioTrack
                    "Love The One You're With"
                    "audio/Love-The-One.mp3"
                    "Love The One You're With.mp3"
                    Nothing
                ]
            ]
        
arkivPage : Html Msg
arkivPage =
     div
         [ style "display" "grid"
         , style "grid-template-columns" "repeat(auto-fit, minmax(260px, 1fr))"
         , style "gap" "20px"
         , style "margin-top" "30px"
         ]
         [ archiveCard "🎵" "Låtar" "Inspelningar och äldre material."
         , archiveCard "📷" "Bilder" "Bilder från spelningar och repetitioner."
         , archiveCard "🎬" "Videor" "Klipp från konserter och andra framträdanden."
         ]
     


