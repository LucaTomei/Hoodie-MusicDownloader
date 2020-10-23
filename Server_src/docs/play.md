# PLAY

Used to play song directly on browser.


**URL** : `/api/play/:filename`

**Method** : `GET`

**Auth required** : YES

**Permissions required** : None


## Success Responses


**Code** : `200 OK`

## Code

```javascript
 app.get('/api/play/:filename', (req,res) => {
    const file = __dirname + '/DOWNLOADS/'+req.params.filename+'.mp3';

    res.sendFile(file)
})
```
