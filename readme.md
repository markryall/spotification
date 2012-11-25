# Spotification

A rudimentary remote jukebox for spotify (for mac os x only).

## Installation

Install ruby 1.9.3 and bundler

Clone this repository:

    git clone http://github.com/markryall/spotification.git
    cd spotification

Install prerequisites:

    bundle

## Running

There are two processes: the web server process and the player.

The web server allows remote users to search spotify for tracks (using the spotify web api) and enqueue them.  If configiured, the web server can also show the recently played tracks for a given user on lastfm (using the lastfm api).

The player monitors the spotify application and the queue (using applescript - hence the mac os x restriction).  When spotify has stopped playing, the player will tell it to start playing the next track in the queue.  Note that this queue has nothing to do with the spotify queue.

So in one terminal session:

    rackup

This starts a sinatra application running (on port 9292 by default).

In another terminal session:

    ./bin/spotification_player

## Usage

There's really not much too this:

To search for tracks, browse to http://localhost:9292/tracks and execute a search.

Click 'queue' to enqueue a search result or play to launch spotify on your machine.

Note that the player process will wait until the spotify status is 'stopped'.  If you pause, the player will remain paused.

## last.fm

In case you (like me) have configured spotify to scrobble anything you play to lastfm then you can use this to show recently played tracks (played using spotify or anything else).

For some unknown reason, lastfm requires an application id to read the recently played tracks for a given user.  To use the '/lastfm' route you will need to create a lastfm application with your lastfm account and set the LASTFM_API_KEY and LAST_FM_USER environment variables.

## Future Plans

* a menu would be nice
* search by artist
* search by album
* less appalling user interface