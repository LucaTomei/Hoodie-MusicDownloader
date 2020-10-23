# Music Downloader Server

This is the server used to download songs from Deezer.

## Configuration

```shell
npm install
npm audit fix
npm run start
```

### API Documentation

Endpoints for viewing and manipulating Deezer Songs are:

* [Post Deezer ARL](docs/post_arl.md) : `POST /api/arl/`
* [Search Song](docs/search.md)) : `GET api/search/song_name`
* [Download Song](docs/stream.md)) : `POST /api/stream`
* [Play Song](docs/play.md)) : `GET /api/play/song_id`
