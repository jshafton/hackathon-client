Channels
========

**Public channel**: `public`

**Private server channel**: `private-server`

**Private player channel**: `private-#{URL-encode(player_name)`


Events
======

Player added
------------
Triggered by: `client`

Channel: `private server`

Event name: `client-player-added`

Sample JSON:

    {
      "id": "fuckthisshit",
      "info": {
        "name": "fuckthisshit",
        "email": "fuckthis@shit.com",
        "private_channel": "private-fuckthisshit",
        "gravatar_url": "http://someurl/"
      }
    }

Player dropped
--------------
Triggered by: `client`

Channel: `private server`

Event name: `client-player-dropped`

Sample JSON:

    {
      "id": "fuckthisshit",
      "info": {
        "name": "fuckthisshit",
        "email": "fuckthis@shit.com",
        "private_channel": "private-fuckthisshit",
        "gravatar_url": "http://someurl/"
      }
    }

Round started
-------------
Triggered by: `server`

Channel: `public`

Event name: `game-round-started`

Sample JSON:

    {
      "round_id": "xxx",
      "image_url": "xxx",
      "players":
        [
          { "name": "player 1", "type": "player", "current_score": 50, "rounds_played": 2, "gravatar_url": "xxx" },
          { "name": "player 2", "type": "judge", "current_score": 30, "rounds_played": 8, "gravatar_url": "xxx" },
          { "name": "player 3", "type": "player", "current_score": 52, "rounds_played": 6, "gravatar_url": "xxx" }
        ]
    }

Guess submitted
---------------
Triggered by: `web`

Channel: `private player`

Event name: `client-guess-submitted`

Sample JSON:

    {
      "round_id": "xxx",
      "player": "player 1",
      "guess": "Super guess 1"
    }

Guess submitted
---------------
Triggered by: `web`

Channel: `public`

Event name: `client-guess-submitted`

Sample JSON:

    {
      "round_id": "xxx",
      "player": "player 1",
    }

Judging ready
-------------
Triggered by: `server`

Channel: `private player`

Event name: `game-judging-ready`

Sample JSON:

    {
      "round_id": "xxx",
      "players":
        [
          { "name": "player 1", "type": "player", "current_score": 50, "rounds_played": 2, "gravatar_url": "xxx", "guess": "Super guess 1" },
          { "name": "player 3", "type": "player", "current_score": 52, "rounds_played": 6, "gravatar_url": "xxx" , "guess": "Super guess 3" }
        ]
    }

Judging complete
----------------
Triggered by: `web`

Channel: `public`

Event name: `client-judging-completed`

Sample JSON:

    {
      "round_id": "xxx",
      "winning_player": "player 1"
    }

Judging ready
-------------
Triggered by: `server`

Channel: `public`

Event name: `game-round-completed`

Sample JSON:

    {
      "round_id": "xxx",
      "winning_player": "player 1",
      "players":
        [
          { "name": "player 1", "type": "player", "current_score": 55, "rounds_played": 2, "gravatar_url": "xxx", "guess": "Super guess 1" },
          { "name": "player 3", "type": "player", "current_score": 52, "rounds_played": 6, "gravatar_url": "xxx" , "guess": "Super guess 3" }
        ]
    }
