# POST ARL 

Before downloading music from Deezer you need to authenticate yourself on the website and extract the key "arl" from the cookies.


**URL** : `/api/arl/`

**Method** : `POST`

**Auth required** : YES

**Permissions required** : None

**Data constraints** : 

```json
{
    "arl": "[192 chars]"
}
```

## Success Responses


**Code** : `200 OK`

## Code

```javascript
app.post('/api/arl', (req,res) => {

    console.log("arl="+req.body.arl)
    console.log(httpHeaders.cookie)

    httpHeaders.cookie = "arl="+req.body.arl
    initApp(() => {

        res.send("Success!")
    });

})


function initApp(_callback) {
    process.on('unhandledRejection', (reason, p) => {
        console.error('\n' + reason + '\nUnhandled Rejection at Promise' + JSON.stringify(p) + '\n');
    });

    process.on('uncaughtException', (err) => {
        console.error('\n' + err + '\nUncaught Exception thrown' + '\n');
        process.exit(1);
    });

    

    nodePath.normalize(DOWNLOAD_DIR).replace(/\/$|\\$/, '');
    nodePath.normalize(PLAYLIST_DIR).replace(/\/$|\\$/, '');

    //StartApp
    initRequest();

        downloadSpinner.text = 'Initiating Deezer API...';
        downloadSpinner.start();

        initDeezerApi().then(() => {
            downloadSpinner.succeed('Connected to Deezer API');
            selectedMusicQuality = musicQualities.MP3_320;

            _callback();

        }).catch((err) => {
            if ('Wrong Deezer credentials!' === err) {
                downloadSpinner.fail('Wrong Deezer credentials!');
                configService.set('arl', null);
                configService.saveConfig();

                startApp();
            } else {
                downloadSpinner.fail(err);
            }
        });


};
```
