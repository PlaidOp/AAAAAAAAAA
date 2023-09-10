<!DOCTYPE html>
<html>
<head>
    <title>HCDE Hub</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            background-color: #f2f2f2;
        }
        .hub-content {
            display: block;
        }
        .youtube-button, .kahoot-button {
            background-color: #333;
            color: #fff;
            border: none;
            border-radius: 4px;
            font-size: 14px;
            cursor: pointer;
            padding: 10px 20px;
            margin: 10px;
        }
        .footer {
            margin-top: 30px;
            font-size: 12px;
        }
        .email-link {
            color: blue;
            text-decoration: underline;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="hub-content">
        <h1>HCDE Hub</h1>
        <button class="youtube-button" id="show-youtube">YouTube Unblocked</button>
        <button class="kahoot-button" id="show-kahoot">Kahoot Botter</button>
    </div>
    
    <div class="youtube-unblocked-content" style="display: none;">
        <!DOCTYPE html>
        <html>
        <head>
            <title>YouTube Unblocked</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    text-align: center;
                    background-color: #f2f2f2;
                }
                input {
                    padding: 8px;
                    margin: 8px;
                    border: 1px solid #ccc;
                    border-radius: 4px;
                    font-size: 14px;
                    width: 200px;
                }
                button {
                    padding: 10px 20px;
                    background-color: #333;
                    color: #fff;
                    border: none;
                    border-radius: 4px;
                    font-size: 14px;
                    cursor: pointer;
                    margin-right: 10px;
                }
                iframe {
                    margin-top: 20px;
                    width: 640px;
                    height: 360px;
                }
                .video-title {
                    margin-top: 10px;
                    font-size: 16px;
                    font-weight: bold;
                }
                .controls {
                    margin-top: 10px;
                    display: flex;
                    justify-content: center;
                }
                .play-button, .pause-button {
                    background-color: #333;
                    color: #fff;
                    border: none;
                    border-radius: 4px;
                    font-size: 14px;
                    cursor: pointer;
                    margin: 0 10px;
                    padding: 5px 10px;
                }
                .saved-links {
                    margin-top: 20px;
                    font-size: 16px;
                    font-weight: bold;
                }
                .saved-link-item {
                    font-size: 14px;
                    margin-top: 5px;
                }
                .remove-link {
                    color: red;
                    cursor: pointer;
                    margin-left: 5px;
                }
                .footer {
                    margin-top: 30px;
                    font-size: 12px;
                }
                .email-link {
                    color: blue;
                    text-decoration: underline;
                    cursor: pointer;
                }
            </style>
        </head>
        <body>
            <h1>YouTube Unblocked</h1>
            <input id="url" type="text" placeholder="Enter YouTube Link" required>
            <button id="submit">Watch</button>
            <button id="fullscreen">Full Screen</button>
            <div id="video-holder"></div>
            <div class="video-title"></div>
            <div class="controls">
                <button id="play" class="play-button" style="display: none;">Play</button>
                <button id="pause" class="pause-button" style="display: none;">Pause</button>
            </div>
            <button id="save-link">Save Link</button>
            <div class="saved-links">
                <h2>Saved Links</h2>
                <ul id="saved-link-list"></ul>
            </div>
            <div class="footer">
                Made by Stone - <span class="email-link" onclick="window.location.href='mailto:ns47190@students.hcde.org'">ns47190@students.hcde.org</span>
            </div>
            <script>
                var videoPlayer;
                var videoTitle;

                // Load saved links from localStorage
                var savedLinks = JSON.parse(localStorage.getItem("savedLinks")) || [];

                function loadSavedLinks() {
                    var savedLinksString = localStorage.getItem("savedLinks");
                    if (savedLinksString) {
                        savedLinks = JSON.parse(savedLinksString);
                        displaySavedLinks();
                    }
                }

                function saveLinksToLocalStorage() {
                    localStorage.setItem("savedLinks", JSON.stringify(savedLinks));
                }

                loadSavedLinks();

                document.getElementById("submit").addEventListener("click", function () {
                    var url = document.getElementById("url").value;
                    var videoId = url.match(/v=([^&]+)/);
                    if (videoId && videoId[1]) {
                        videoId = videoId[1];
                        var iframe = document.createElement("iframe");
                        iframe.src = "https://www.youtube-nocookie.com/embed/" + videoId;
                        iframe.frameborder = "0";
                        iframe.allowfullscreen = "";
                        document.getElementById("video-holder").innerHTML = "";
                        document.getElementById("video-holder").appendChild(iframe);
                        videoPlayer = iframe;

                        // Display video title
                        fetch("https://noembed.com/embed?url=https://www.youtube.com/watch?v=" + videoId)
                            .then(response => response.json())
                            .then(data => {
                                document.querySelector(".video-title").textContent = data.title;
                            });

                        // Show play button
                        document.getElementById("play").style.display = "inline-block";
                    }
                });

                document.getElementById("fullscreen").addEventListener("click", function () {
                    if (videoPlayer) {
                        if (videoPlayer.requestFullscreen) {
                            videoPlayer.requestFullscreen();
                        } else if (videoPlayer.mozRequestFullScreen) {
                            videoPlayer.mozRequestFullScreen();
                        } else if (videoPlayer.webkitRequestFullscreen) {
                            videoPlayer.webkitRequestFullscreen();
                        }
                    }
                });

                document.getElementById("play").addEventListener("click", function () {
                    if (videoPlayer && videoPlayer.contentWindow) {
                        videoPlayer.contentWindow.postMessage('{"event":"command","func":"playVideo","args":""}', '*');
                        document.getElementById("play").style.display = "none";
                        document.getElementById("pause").style.display = "inline-block";
                    }
                });

                document.getElementById("pause").addEventListener("click", function () {
                    if (videoPlayer && videoPlayer.contentWindow) {
                        videoPlayer.contentWindow.postMessage('{"event":"command","func":"pauseVideo","args":""}', '*');
                        document.getElementById("play").style.display = "inline-block";
                        document.getElementById("pause").style.display = "none";
                    }
                });

                document.getElementById("save-link").addEventListener("click", function () {
                    var url = document.getElementById("url").value;
                    if (url) {
                        savedLinks.push(url);
                        saveLinksToLocalStorage();
                        displaySavedLinks();
                    }
                });

                function displaySavedLinks() {
                    var savedLinkList = document.getElementById("saved-link-list");
                    savedLinkList.innerHTML = "";
                    savedLinks.forEach(function (link, index) {
                        var listItem = document.createElement("li");
                        listItem.className = "saved-link-item";
                        listItem.textContent = link;
                        var removeButton = document.createElement("span");
                        removeButton.className = "remove-link";
                        removeButton.textContent = "X";
                        removeButton.addEventListener("click", function () {
                            removeSavedLink(index);
                        });
                        listItem.appendChild(removeButton);
                        savedLinkList.appendChild(listItem);
                    });
                }

                function removeSavedLink(index) {
                    if (index >= 0 && index < savedLinks.length) {
                        savedLinks.splice(index, 1);
                        saveLinksToLocalStorage();
                        displaySavedLinks();
                    }
                }
            </script>
        </body>
        </html>
    </div>

    <div class="footer">
        Made by Stone - <span class="email-link" onclick="window.location.href='mailto:ns47190@students.hcde.org'">ns47190@students.hcde.org</span>
    </div>

    <script>
        document.getElementById("show-youtube").addEventListener("click", function () {
            document.querySelector(".hub-content").style.display = "none";
            document.querySelector(".youtube-unblocked-content").style.display = "block";
            document.querySelector(".kahoot-botter-content").style.display = "none";
        });

        document.getElementById("show-kahoot").addEventListener("click", function () {
            document.querySelector(".hub-content").style.display = "none";
            document.querySelector(".youtube-unblocked-content").style.display = "none";
            document.querySelector(".kahoot-botter-content").style.display = "block";
        });
    </script>
</body>
</html>
