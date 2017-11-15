#!/usr/bin/env python
# -*- coding: utf-8 -*-

import json
import os
import spotipy
import spotipy.util as util
from spotipy.oauth2 import SpotifyClientCredentials
import sys


def create_token_file():
    token_params = {
        "client_id": "YOUR_CLIENT_ID",
        "client_secret": "YOUR_CLIENT_SECRET",
        "redirect_uri": "YOUR_REDIRECT_URI",
    }
    token_filename = os.path.join(os.path.expanduser("~"), ".spotifytoken")
    with open(token_filename, "w") as fp:
        json.dump(token_params, fp)

def load_token_file():
    token_filename = os.path.join(os.path.expanduser("~"), ".spotifytoken")
    with open(token_filename, "r") as fp:
        token_params = json.load(fp)
    return token_params

class Spotimy(object):

    def __init__(self):
        self.get_sp_client()

    def get_sp_client(self):
        scope = 'user-library-read playlist-modify-private playlist-modify-public user-library-modify'
        token_params = load_token_file()

        if len(sys.argv) > 1:
            self.username = sys.argv[1]
        else:
            print "Usage: %s username" % (sys.argv[0],)
            sys.exit()

        token = util.prompt_for_user_token(self.username, scope, **token_params)

        if token:
            self.sp = spotipy.Spotify(auth=token)
        else:
            print "Can't get token for", self.username
            sys.exit()

    def add_my_plist_tracks_to_library(self, save_playlists):
        for plist in self.sp.current_user_playlists()["items"]:
            if plist["name"] in save_playlists:
                print plist["name"]
                self.add_playlist_tracks_to_library(plist)

    def add_playlist_tracks_to_library(self, playlist):
        tracks = self.get_playlist_tracks(playlist)
        while len(tracks) > 48:
            subtracks = tracks[:48]
            self.sp.current_user_saved_tracks_add(tracks=subtracks)
            tracks = tracks[48:]
        self.sp.current_user_saved_tracks_add(tracks=tracks)

    def get_playlist_by_name(self, plist_name):
        for plist in self.sp.current_user_playlists()["items"]:
            if plist["name"] == plist_name:
                return plist

    def get_playlist_tracks(self, playlist):
        if not playlist:
            return []
        tracks = self.sp.user_playlist(
            self.username, playlist["id"], fields="tracks,id")
        return map(lambda t: t["track"]["id"], tracks["tracks"]["items"])

    def add_library_to_sorting_plist(self, needs_sorting_playlist, sort_playlists):
        offset = 0
        limit = 50
        biglimit = 100
        my_library = []
        total = None
        already_sorted = []
        needs_sorting_playlist = self.get_playlist_by_name(needs_sorting_playlist)
        needs_sorting = self.get_playlist_tracks(needs_sorting_playlist)
        for plname in sort_playlists:
            already_sorted.extend(self.get_playlist_tracks(self.get_playlist_by_name(plname)))
        import pdb; pdb.set_trace()
        while len(my_library) < biglimit and (total is None or len(my_library) < total):
            print offset
            saved_tracks = self.sp.current_user_saved_tracks(limit=limit, offset=offset)

            my_library.extend(saved_tracks["items"])
            total = saved_tracks["total"]
            offset += limit
        for track in my_library:
            print track["track"]["name"]
            if track["track"]["id"] not in needs_sorting:
                if track["track"]["id"] in sort_playlists:
                    print "already sorted"
                else:
                    print "add to needs_sorting"
                    self.sp.user_playlist_add_tracks(
                        self.username, needs_sorting_playlist["id"],
                        [track["track"]["id"], ],
                    )


def main():
    sp = Spotimy()
    needs_sorting_playlist = "needs sorting"
    save_playlists = [
        "Baume au coeur", "piano", "Douceur, detente",
        "Morning boost up", "Forget everything and get into a blind trance",
        "Steampunk and strange stuff", "Nostalgie", "Pump It up !!",
        "share it maybe", "Frissons à l'unisson", "Ondulations",
        "Route 66 and other highways", "Will you dance with me ?",
        "Know me through music I love...", "Interesting covers", "MedFan", "Blues junkie",
        "Jazzy or not", "Cosy Road Trip", "Mes titres Shazam", "Rock Box",
        "À tester, découvrir", "Épique",
        "Viens danser tout contre moi", "Endless Trip on a Steel Dragonfly", "Cosy",
        "Enfants", "Sélection", "Favoris des radios", needs_sorting_playlist,
    ]
    # sp.add_my_plist_tracks_to_library(save_playlists)
    sp.add_library_to_sorting_plist(needs_sorting_playlist, save_playlists)


if __name__ == "__main__":
    main()
