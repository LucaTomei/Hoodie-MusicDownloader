# SEARCH

This endpoint is used to search for songs on deezer.


**URL** : `/api/stream`

**Method** : `POST`

**Auth required** : YES

**Permissions required** : None

**Data** : 

```json
{
    "deezer_url": "[string]"
}
```

## Success Responses


**Code** : `200 OK`

## Code

```javascript
 app.post('/api/stream', (req,res) => {
        
    var jsonData = {}

    //Get the song info from the deezer api
    axios.get(req.body.deezer_url.replace("www","api").replace("/us/","/")).then((apiResponse) => {
        jsonData = apiResponse.data;
    })


    startDownload(req.body.deezer_url, (filename) => {
        res.json({filename: filename, apiData: jsonData})
    })


})


function startDownload(deezerUrl, _callback) {

    const deezerUrlParts = getDeezerUrlParts(deezerUrl);

    downloadStateInstance.start(deezerUrlParts.type, deezerUrlParts.id);

    switch (deezerUrlParts.type) {
        case 'album':
        case 'playlist':
        case 'profile':
            return downloadMultiple(deezerUrlParts.type, deezerUrlParts.id).then(() => {
                downloadStateInstance.finish(true);
            });
        case 'track':
            downloadStateInstance.updateNumberTracksToDownload(1);

            return downloadSingleTrack(deezerUrlParts.id).then((filename) => {
            
                
                downloadStateInstance.finish(true);
                _callback(filename);
            });
    }
}

```
    