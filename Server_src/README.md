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

* [Post Deezer ARL]() : `POST /api/arl/`
* [Search Song]() : `GET api/search/song_name`
* [Download Song]() : `POST /api/stream`
* [Play Song]() : `GET /api/play/song_id`
