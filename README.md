# ExChess

A Phoenix server for playing live games of chess via algebraic chess
notation.

## Starting the server

To start:

```
$ mix deps.get
$ mix ecto.migrate
$ iex -S mix phx.server
```

The API will be hosted at [`localhost:4000`](http://localhost:4000).

## Starting the UI

With yarn:

```
$ cd ui
$ yarn
$ yarn dev
```

With npm:

```
$ cd ui
$ npm install
$ npm run dev
```

The UI will appear at [`localhost:4321`](http://localhost:4321).

## API docs

All requests except those to `/auth` require a JWT in the
Authorization header. Example:

```
POST /game
Authorization: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9.TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeFONFh7HgQ

...body
```

### POST /api/auth/signup

Create an account.

Body:

- `username`: your desired username
- `password`: your password

Example response:

```
{
	"data": {
		"jwt": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJVc2VyOmE4ODA1NDBjLTA5OGMtNDgyMy04ZmM3LWUwYzM0ZjEzMjIyNyIsImV4cCI6MTQ5NzUyMzczMCwiaWF0IjoxNDk2MzE0MTMwLCJpc3MiOiJFeENoZXNzIiwianRpIjoiM2JmOWI1YjctNGMxMS00NWEyLTk0YjUtYmI3MzQzYzRmODE5IiwicGVtIjp7fSwic3ViIjoiVXNlcjphODgwNTQwYy0wOThjLTQ4MjMtOGZjNy1lMGMzNGYxMzIyMjciLCJ0eXAiOiJhY2Nlc3MifQ.1Iu7I8vJWp_2cbbXh9F29Fv_7q9HFx2HzOBUc1Ea911Ek2t4bcRiRsALdUuP71mubj5zAw05JjMaLR5GpOwjwQ",
		"identity": {
			"username": "sonic",
			"id": "a880540c-098c-4823-8fc7-e0c34f132227"
		}
	}
}
```

### POST /api/auth/login

Retrieve a JWT for your account.

Body:

- `username`: your username
- `password`: your password

Example response:

```
{
	"data": {
		"jwt": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJVc2VyOmE4ODA1NDBjLTA5OGMtNDgyMy04ZmM3LWUwYzM0ZjEzMjIyNyIsImV4cCI6MTQ5NzUyMzczMCwiaWF0IjoxNDk2MzE0MTMwLCJpc3MiOiJFeENoZXNzIiwianRpIjoiM2JmOWI1YjctNGMxMS00NWEyLTk0YjUtYmI3MzQzYzRmODE5IiwicGVtIjp7fSwic3ViIjoiVXNlcjphODgwNTQwYy0wOThjLTQ4MjMtOGZjNy1lMGMzNGYxMzIyMjciLCJ0eXAiOiJhY2Nlc3MifQ.1Iu7I8vJWp_2cbbXh9F29Fv_7q9HFx2HzOBUc1Ea911Ek2t4bcRiRsALdUuP71mubj5zAw05JjMaLR5GpOwjwQ",
		"identity": {
			"username": "sonic",
			"id": "a880540c-098c-4823-8fc7-e0c34f132227"
		}
	}
}
```

### GET /api/identity

Retrieve your own identity.

Example response:

```
{
	"data": {
		"username": "sonic",
		"id": "a880540c-098c-4823-8fc7-e0c34f132227"
	}
}
```

### GET /api/user/:id

Get a user's profile by ID.

Example response:

```
{
	"data": {
		"username": "sonic",
		"id": "a880540c-098c-4823-8fc7-e0c34f132227"
	}
}
```

### GET /api/game

Get the list of games.

Query parameters:

- `status`: filter by game status. Status can be `waiting`, `playing`,
  or `finished`.

Example response:

```
{
	"data": [
		{
			"status": "playing",
			"playerTwoPresent": true,
			"playerTwo": {
				"username": "anon",
				"id": "3096bc6c-f808-4fc3-a871-473936e7315e"
			},
			"playerOneTurn": true,
			"playerOnePresent": true,
			"playerOne": {
				"username": "foobar",
				"id": "1a567c36-d347-4891-8c99-815a8117a4d1"
			},
			"moves": [
                "e4,e5"
			],
			"id": "da2bfa7f-7fb3-4f16-89cd-09be89363877"
		}
	]
}
```

### GET /api/game/:id

Get a specific game by ID.

Example response:

```
{
	"data": {
		"status": "playing",
		"playerTwoPresent": true,
		"playerTwo": {
			"username": "anon",
			"id": "3096bc6c-f808-4fc3-a871-473936e7315e"
		},
		"playerOneTurn": true,
		"playerOnePresent": true,
		"playerOne": {
			"username": "foobar",
			"id": "1a567c36-d347-4891-8c99-815a8117a4d1"
		},
		"moves": [
			"e4,e5",
		],
		"id": "da2bfa7f-7fb3-4f16-89cd-09be89363877"
	}
}
```

### POST /api/game

Start a new game. You will be player 1. The game status will be
"waiting" until you and another player join it via web socket.

Body: no body is required.

Example response:

```
{
	"data": {
		"status": "waiting",
		"playerTwoPresent": false,
		"playerTwo": null,
		"playerOneTurn": true,
		"playerOnePresent": false,
		"playerOne": {
			"username": "sonic",
			"id": "a880540c-098c-4823-8fc7-e0c34f132227"
		},
		"moves": [],
		"id": "741e300c-339b-488c-a69b-755ae73075b7"
	}
}
```

