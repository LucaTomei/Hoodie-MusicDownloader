# SEARCH

This endpoint is used to search for songs on deezer.


**URL** : `/api/search/searchTerm`

**Method** : `GET`

**Auth required** : YES

**Permissions required** : None


## Success Responses


**Code** : `200 OK`

## Code

```javascript
app.get('/api/search/:term', (req,res) => {
    

    axios.get("https://api.deezer.com/search?q=track:\""+req.params.term+"\"").then((response) => {
        //console.log(response.data)
        res.json(response.data)
    })

   
})
```
