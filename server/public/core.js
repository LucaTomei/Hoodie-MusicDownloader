// public/core.js
var meanLoadr = angular.module('musicdownloader', []);


function formatTime(secs) {
    var minutes = Math.floor(secs / 60) || 0;
    var seconds = (secs - minutes * 60) || 0;

    return minutes + ':' + (seconds < 10 ? '0' : '') + seconds;
  }

meanLoadr.controller('mainController',($scope, $http) => {

    $scope.sound = null;
    $scope.vol = 100
    $scope.formData = {};
    $scope.formData.arl = document.cookie.slice(4);

    $scope.currentSong = {};

    $scope.arlEntered = false;

    $scope.arlSubmitted = false;

    $scope.deezerUrlEntered = false;

    $scope.deezerUrlSubmitted = false;

    $scope.searchData = {}



    $scope.updateVolume = () => {
        Howler.volume(document.getElementById("volume").value / 100)
    }

    $scope.updateSeek = () => {
        $scope.sound.seek(document.getElementById("seek").value)
    }    

    // when submitting the arl form, send the it to the node API
    $scope.submitArl = () => {


        if ($scope.formData.arl.length != 192)
            return

        $scope.arlSubmitted = true;



        $http.post('/api/arl/', $scope.formData)
            .then((response) => {
                $scope.formData = {}; // clear the form so our user is ready to enter another
                $scope.arlEntered = true;
                console.log(response.data);


            })
            .catch((err) => {
                console.log(err)
            })
    }; 

    // when submitting the add form, send the text to the node API
    $scope.createStream = () => {

        if ($scope.sound)
            $scope.sound.stop();

        $scope.deezerUrlSubmitted = true;
        $http.post('/api/stream/', $scope.formData)
            .then((response) => {

                $scope.currentSong.apiData = response.data.apiData

                console.log($scope.currentSong)

                console.log(response.data);
                $scope.deezerUrlEntered = true;
                $scope.currentSong.paused = false;
                Howler.unload();
                $scope.sound = new Howl({
                    format: ['mp3'],
                    html5: true,
                    src: ['/api/play/'+response.data.filename],
                    onplay: function() {
                        // Display the duration.
                        $scope.currentSong.duration = formatTime(Math.round($scope.sound.duration()))


                        $scope.currentSong.paused = false

                        if (!document.getElementById("seek"))
                            document.getElementById("seekWrapper").innerHTML += '<input type="range" id="seek" value="0" min="0" max='+Math.floor($scope.sound.duration())+' />'
                        

                        document.getElementById("seek").addEventListener('change', () => {
                            $scope.sound.seek(document.getElementById("seek").value)
                        })

                        setInterval(() => {
                            
                            document.getElementById("seek").value = $scope.currentSong.seek = $scope.sound.seek()

                            document.getElementById("songTime").innerHTML = formatTime(Math.round($scope.sound.seek()))+" | "+formatTime(Math.round($scope.sound.duration()))
                        },100)

                      },
                    onload: function() {
                        
                    }

                  });
                
                
                
                
                $scope.sound.play();
                $scope.deezerUrlSubmitted = false;
            })
    };
    
    
    $scope.createSearch = (searchTerm) => {

        $http.get('/api/search/'+searchTerm, {})
            .then((response) => {
                    console.log(response.data)
                    $scope.searchData = response.data.data.slice(0,5)
                    console.log( $scope.searchData)

            })
        
    }


});
