{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Char (isAlphaNum)
import qualified Data.Text.Lazy as Text
import Network.HTTP.Types.Status (status404)
import Web.Scotty

safeFilename :: String -> Bool
safeFilename filename =
    not (null filename)
        && all (\c -> isAlphaNum c || c `elem` ("._-" :: String)) filename

main :: IO ()
main = scotty 3000 $ do
    get "/" $ file "../index.html"
    get "/noter" $ file "../index.html"
    get "/repertoar" $ file "../index.html"
    get "/arkiv" $ file "../index.html"

    get "/elm.js" $ file "../elm.js"

    get "/audio/:filename" $ do
        filename <- captureParam "filename"
        let name = Text.unpack filename

        if safeFilename name then
            file $ "../audio/" ++ name
        else do
            status status404
            text "Invalid audio filename"

    get "/media/:filename" $ do
        filename <- captureParam "filename"
        let name = Text.unpack filename

        if safeFilename name then do
            file $ "../media/" ++ name
            setHeader "Content-Type" "image/svg+xml"
        else do
            status status404
            text "Invalid media filename"

