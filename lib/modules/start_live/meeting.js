(function () {
  "use strict";

  const isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
  const audioInputSelect = document.querySelector("select#audioSource");
  const videoInputSelect = document.querySelector("select#videoSource");
  const selectors = [audioInputSelect, videoInputSelect];
  let muteCamera = document.querySelector("input#muteCamera");
  let muteAudio = document.querySelector("input#muteAudio");
  let watching = false;
  let socket;
  let constraints;
  let localStream;
  let meetingType;
  let multiStreamRecorder;
  let arrayOfStreams = [];
  let arrayOfStreams_ids = [];
  let arrayOfStreams_recording = [];
  let currentMeetingTime;
  let layoutContainer = document.getElementById("videos");
  let layout = initLayoutContainer(layoutContainer, {
    fixedRatio: false,
  }).layout;

  let uploader;
  let screenStream;
  let localVideoTrack;
  let mouseMoveTimer;
  let displayFileUrl;
  let resizeTimeout;
  let connections = [];
  let usernames = [];
  let events = [];
  let settings = {};
  let configuration = {};
  let facingMode = "user";
  let micMuted = true;
  let videoMuted = true;
  let screenShared = false;
  let inviteMessage = "Hey there! Join me for a meeting at this link: ";
  let timer = new easytimer.Timer();
  let notificationTone = new Audio(url + "/assets/sounds/notification.mp3");
  let user_sharing_screen = -1;
  let user_speaking_show = -1;
  let user_speaking_show_id = "";

  //get the details
  (function () {
    $.ajax({
      url: url + "/get-live-details",
    })
      .done(function (data) {
        data = JSON.parse(data);

        if (data.success) {
          settings = data.data;
          // console.log(settings);
          initializeSocket(settings.signalingURL);
          $("#joinMeeting").attr("disabled", false);
          $("#watchMeeting").attr("disabled", false);

          configuration = {
            iceServers: [
              {
                urls: settings.stunUrl,
              },
              {
                urls: settings.turnUrl,
                username: settings.turnUsername,
                credential: settings.turnPassword,
              },
            ],
          };
        } else {
          showError("Unable to get session details.");
        }
      })
      .catch(function () {
        showError("Unable to get session details.");
      });
  })();

  //connect to the signaling server and add listeners
  function initializeSocket(signalingURL) {
    console.log("*************************");
    console.log(signalingURL);
    console.log("*************************");
    socket = io.connect(signalingURL);
    uploader = new SocketIOFileUpload(socket);

    //handle socket file event
    socket.on("file", function (data) {
      if ($(".chat-panel").is(":hidden")) {
        $("#openChat").addClass("notify");
        showOptions();
        notificationTone.play();
      }
      appendFile(data.file, data.extension, data.username, false);
    });

    //listen for socket message event and handle it
    socket.on("message", function (data) {
      data = JSON.parse(data);

      switch (data.type) {
        case "join":
          handleJoin(data);
          break;
        case "offer":
          handleOffer(data);
          break;
        case "answer":
          handleAnswer(data);
          break;
        case "candidate":
          handleCandidate(data);
          break;
        case "leave":
          handleLeave(data);
          break;
        case "checkMeetingResult":
        case "permissionResult":
          checkMeetingResult(data);
          break;
        case "meetingMessage":
          handlemeetingMessage(data);
          break;
        case "micChanged":
          handlemicChanged(data);
          break;
        case "removeWatch":
          handlRemoveWatch(data);
          break;
        case "permission":
          handlePermission(data);
          break;
        case "info":
          showInfo(data.message);
          break;
        case "kick":
          showInfo("I'm out of the meeting!");
          reload(0);
          break;
        case "mute":
          showInfo("You have been muted by the session manager!");
          localStream.getAudioTracks().forEach((track) => {
            track.enabled = false;
            console.log("11");
          });
          $("#toggleMic")
            .html('<i class="fa fa-microphone-slash"></i>')
            .removeClass("green");

          micMuted = true;
          break;
        case "volume_up":
          showInfo("Your audio has been played by the session manager!");
          localStream.getAudioTracks().forEach((track) => {
            track.enabled = true;
            console.log("11");
          });
          $("#toggleMic")
            .html('<i class="fa fa-microphone"></i>')
            .addClass("green");
          micMuted = false;
          break;
        case "screenSharing":
          if (data.start == "started") {
            user_sharing_screen = "#container-" + data.socket_id;
            $("#video-" + data.socket_id).attr(
              "style",
              "-webkit-transform: scaleX(1) !important;transform:scaleX(1) !important"
            );

            arrayOfStreams_recording = [arrayOfStreams[data.socket_id]];
          } else {
            arrayOfStreams_recording = [];
            user_speaking_show = -1;
            $("#video-" + data.socket_id).attr(
              "style",
              "-webkit-transform: scaleX(-1) !important;transform:scaleX(-1) !important"
            );
            user_sharing_screen = -1;
            $("#videos div").removeClass("hide");
            layout();
          }
          if (user_sharing_screen != -1) {
            $("#videos div").addClass("hide");
            $(user_sharing_screen).removeClass("hide");
            layout();
          }
          break;
        case "userTalking":
          if (data.start == "started") {
            if (data.socket_id == socket.id) {
              user_speaking_show_id = ".localVideoContainer";
            } else {
              user_speaking_show_id = "#container-" + data.socket_id;
            }
            if (user_speaking_show == 1) {
              $("#videos div").addClass("hide");
              $(user_speaking_show_id).removeClass("hide");
              layout();
            }
          } else {
            user_speaking_show = -1;
          }
          break;
        case "currentTime":
          //update the timer if the user joins an existing room
          timer.stop();
          timer.start({
            precision: "seconds",
            startValues: {
              seconds: data.currentTime,
            },
            target: {
              seconds: settings.timeLimit * 60 - 60,
            },
          });
          break;
      }
    });

    //listen on sendFile button click event
    uploader.listenOnSubmit($("#sendFile")[0], $("#file")[0]);

    //start file upload
    uploader.addEventListener("start", function (event) {
      event.file.meta.extension = event.file.name.substring(
        event.file.name.lastIndexOf(".")
      );
      event.file.meta.username = userInfo.username;
      showInfo("download file ...");
    });

    //append file when file upload is completed
    uploader.addEventListener("complete", function (event) {
      appendFile(event.detail.file, event.detail.extension, null, true);
    });

    //handle file upload error
    uploader.addEventListener("error", function (event) {
      showError(event.message);
    });

    //get username for guest users
    if (userInfo && !userInfo.username) {
      userInfo.username = username.value =
        localStorage.getItem("username") || settings.defaultUsername;
    }

    //get item from localStorage and set to html
    // if (muteCamera) {
    //     muteCamera.checked = localStorage.getItem('muteCamera') === 'true';
    // }
    videoQualitySelect.value = localStorage.getItem("videoQuality") || "QVGA";
    // if (passwordRequired) password.value = localStorage.getItem('password');
  }

  //listen for timer update
  // event and display during the meeting
  timer.addEventListener("secondsUpdated", function () {
    currentMeetingTime =
      timer.getTimeValues().minutes * 60 + timer.getTimeValues().seconds;
    $("#timer").html(getCurrentTime());
  });

  //start the timer for last one minute and end the meeting after that
  timer.addEventListener("targetAchieved", function () {
    $("#timer").css("color", "red");
    timer.stop();
    timer.start({
      precision: "seconds",
      startValues: {
        seconds: currentMeetingTime,
      },
    });
    setTimeout(function () {
      showInfo("The meeting is over!");
      reload(1);
    }, 60 * 1000);
  });

  //ajax call to check password, continue to meeting if valid
  $("#passwordCheck").on("submit", function (e) {
    e.preventDefault();

    $("#joinMeeting").attr("disabled", true);
    $("#watchMeeting").attr("disabled", true);

    //show an error if the signaling server is not connected
    if (!socket.connected) {
      showError("Unable to connect to the server, please try again later.");
      $("#joinMeeting").attr("disabled", false);
      $("#watchMeeting").attr("disabled", false);
      return;
    }

    // if (passwordRequired) {
    $.ajax({
      url: url + "/check-live-password",
      data: $(this).serialize(),
      type: "post",
    })
      .done(function (data) {
        data = JSON.parse(data);
        $("#joinMeeting").attr("disabled", false);
        $("#watchMeeting").attr("disabled", false);

        if (data.success) {
          continueToMeeting();
        } else {
          showError("The password is incorrect");
        }
      })
      .catch(function () {
        showError();
        $("#joinMeeting").attr("disabled", false);
        $("#watchMeeting").attr("disabled", false);
      });
    // } else {
    //     continueToMeeting();
    // }
  });

  $("#watchMeeting").on("click", function (e) {
    e.preventDefault();

    $.ajax({
      url: url + "/check-live-password",
      data: $("#passwordCheck").serialize(),
      type: "post",
    })
      .done(function (data) {
        data = JSON.parse(data);
        if (data.success == true) {
          $("#joinMeeting").attr("disabled", true);
          $("#watchMeeting").attr("disabled", true);
          //show an error if the signaling server is not connected
          if (!socket.connected) {
            showError(
              "Unable to connect to the server, please try again later."
            );
            $("#joinMeeting").attr("disabled", false);
            $("#watchMeeting").attr("disabled", false);
            return;
          }
          setToWatching();
          continueToMeeting();
        } else {
          showSuccess("Please enter your name and email!");
        }
      })
      .catch(() => {
        showSuccess("Please enter your name and email!");
      });
  });

  function setToWatching() {
    $("#toggleMic").addClass("hidden");
    // $('#openChat').addClass('hidden');
    $("#add").addClass("hidden");
    $("#openMembers").addClass("hidden");
    $("#screenShare").addClass("hidden");
    $("#toggleVideo").addClass("hidden");
    $("#toggleCam").addClass("hidden");
    $("#recording").addClass("hidden");
    $("#updateDevices").addClass("hidden");
    $("#updateLayouts").addClass("hidden");
    $("#openChat").addClass("hidden");
    watching = true;
    if (localVideo) {
      localVideo.srcObject = undefined;
    }
    if (localStream) {
      localStream.getAudioTracks().forEach((track) => {
        track.enabled = false;
        console.log("11");
      });
      localStream.getVideoTracks().forEach((track) => {
        track.enabled = false;
        console.log("11");
      });
      $("#toggleVideo")
        .html('<i class="fa fa-video-slash"></i>')
        .removeClass("green");
      $("#toggleMic")
        .html('<i class="fa fa-microphone-slash"></i>')
        .removeClass("green");

      micMuted = true;
      videoMuted = true;
      sendMessage({
        type: "micChanged",
        micMuted: true,
        socket_id: socket.id,
        username: userInfo.username,
      });
      $(".localVideoContainer").hide();
    }
    layout();
  }

  function removeWatching() {
    $("#toggleMic").removeClass("hidden");
    // $('#openChat').removeClass('hidden');
    $("#add").removeClass("hidden");
    $("#openMembers").removeClass("hidden");
    $("#toggleVideo").removeClass("hidden");
    $("#toggleCam").removeClass("hidden");
    $("#screenShare").removeClass("hidden");
    $("#recording").removeClass("hidden");
    $("#updateDevices").removeClass("hidden");
    $("#updateLayouts").removeClass("hidden");
    $("#openChat").removeClass("hidden");
    localVideo.srcObject = localStream;
    localStream.getAudioTracks().forEach((track) => {
      track.enabled = false;
    });
    localStream.getVideoTracks().forEach((track) => {
      track.enabled = false;
    });
    $("#toggleVideo")
      .html('<i class="fa fa-video-slash"></i>')
      .removeClass("green");
    $("#toggleMic")
      .html('<i class="fa fa-microphone-slash"></i>')
      .removeClass("green");

    micMuted = true;
    videoMuted = true;
    $(".localVideoContainer").show();
    sendMessage({
      type: "micChanged",
      micMuted: true,
      socket_id: socket.id,
      username: userInfo.username,
    });
    watching = false;
    setTimeout(() => {
      layout();
    }, 1000);
    watingSpeaking();
  }

  //set details into localStorage and notify server to check meeting status
  function continueToMeeting() {
    // meetingType = muteCamera.checked ? 'audio' : 'video';
    meetingType = "video";

    //set details to the localstorage
    localStorage.setItem("muteCamera", $("#muteCamera").is(":checked"));
    // if (passwordRequired) localStorage.setItem('password', password.value);

    userInfo.username = username.value;
    localStorage.setItem("username", userInfo.username);

    if (muteCamera.checked) {
      videoMuted = true;
      $("#toggleVideo")
        .html('<i class="fa fa-video-slash"></i>')
        .removeClass("green");
    } else {
      $("#toggleVideo").html('<i class="fa fa-video"></i>').addClass("green");
    }

    if (muteAudio.checked) {
      micMuted = true;
      $("#toggleMic")
        .html('<i class="fa fa-microphone-slash"></i>')
        .removeClass("green");
    } else {
      $("#toggleMic")
        .html('<i class="fa fa-microphone"></i>')
        .addClass("green");
    }

    //check if the meeting is full or not
    sendMessage({
      type: "checkMeeting",
      username: userInfo.username,
      meetingId: userInfo.meetingId,
      moderator: isModerator,
      authMode: settings.authMode,
      moderatorRights: settings.moderatorRights,
      watch: watching,
      micMuted: micMuted,
      videoMuted: videoMuted,
    });
  }

  //stringify the data and send it to opponent
  function sendMessage(data) {
    socket.emit("message", JSON.stringify(data));
  }

  //get current meeting time in readable format
  function getCurrentTime() {
    return timer.getTimeValues().toString(["hours", "minutes", "seconds"]);
  }

  //reload after a specific seconds
  function reload(seconds) {
    setTimeout(function () {
      window.location.reload();
    }, seconds * 1000);
  }

  //check meeting request
  async function checkMeetingResult(data) {
    if (data.result) {
      //the room has space, get the media and initiate the meeting
      console.log("asdasd");
      constraints = {
        audio: getAudioConstraints(),
        video: getVideoConstraints(),
      };

      try {
        //get user media
        localStream = await navigator.mediaDevices.getUserMedia(constraints);

        if (muteCamera.checked) {
          localStream.getVideoTracks().forEach((track) => {
            track.enabled = false;
          });
          $("#toggleVideo")
            .html('<i class="fa fa-video-slash"></i>')
            .removeClass("green");
          videoMuted = true;
        } else {
          localStream.getVideoTracks().forEach((track) => {
            track.enabled = true;
            console.log("11");
          });
          videoMuted = false;
        }

        if (muteAudio.checked) {
          micMuted = true;
          localStream
            .getAudioTracks()
            .forEach((track) => (track.enabled = false));
          $(this)
            .html('<i class="fa fa-microphone-slash"></i>')
            .removeClass("green");
        } else {
          micMuted = false;
          localStream
            .getAudioTracks()
            .forEach((track) => (track.enabled = true));
          $(this).html('<i class="fa fa-microphone"></i>').addClass("green");
        }

        arrayOfStreams.push(localStream);
        arrayOfStreams_ids.push("Me");

        // watingSpeaking();
      } catch (e) {
        //show an error if the media device is not available
        showError(
          "Unable to get devices, please check permissions and try again. mistake: " +
            e.name
        );
        $("#joinMeeting").attr("disabled", false);
        $("#watchMeeting").attr("disabled", false);
      }

      //init the meeting if media is available
      if (localStream) {
        init();
      }
    } else {
      //there is an error, show it to the user
      showError(data.message);
      $("#joinMeeting").attr("disabled", false);
      $("#watchMeeting").attr("disabled", false);
    }
  }

  function watingSpeaking() {
    // var speechEvents = hark(localStream, {
    //     play: false
    // });
    // speechEvents.start(true);
    //
    //
    // speechEvents.on('speaking', function () {
    //     if (!watching) {
    // console.log('speaking ...');
    // if (can_send_sound) {
    // sendMessage({
    //     type: 'userTalking',
    //     socket_id: socket.id,
    //     start: 'started'
    // });
    // can_send_sound = false;
    // setTimeout(() => {
    //     can_send_sound = true;
    // }, 10000);
    // }
    // if (user_speaking_show == 1) {
    //     $('#videos div').addClass('hide');
    //     $('.localVideoContainer').removeClass('hide');
    //     layout();
    // }
    // }
    //     }
    // });
    // speechEvents.on('stopped_speaking', function () {
    //     if (!watching) {
    // console.log('stopped ...');
    // sendMessage({
    //     type: 'userTalking',
    //     socket_id: socket.id,
    //     start: 'stopped'
    // });
    //     }
    // });
    // speechEvents.on('volume_change', function (volume, threshold) {
    // });
  }

  //notify the moderator for new request
  function handlePermission(data) {
    toastr.info(
      '<br><button type="button" class="btn btn-primary btn-sm clear approve" data-from="' +
        data.fromSocketId +
        '">Approve</button><button type="button" class="btn btn-warning btn-sm clear ml-2 decline" data-from="' +
        data.fromSocketId +
        '">Decline</button>',
      data.username + " He applied to join ",
      {
        tapToDismiss: false,
        timeOut: 0,
        extendedTimeOut: 0,
        newestOnTop: false,
      }
    );
  }

  //notify participant about the request aapproval
  $(document).on("click", ".approve", function () {
    $(this).closest(".toast").remove();
    sendMessage({
      type: "permissionResult",
      result: true,
      toSocketId: $(this).data("from"),
    });
  });

  //notify participant about the request rejection
  $(document).on("click", ".decline", function () {
    $(this).closest(".toast").remove();
    sendMessage({
      type: "permissionResult",
      result: false,
      toSocketId: $(this).data("from"),
      message: "Your request has been declined by the moderator.",
    });
  });

  let recordingStart = false;
  $(document).on("click", "#recording", function () {
    if (!recordingStart) {
      toastr.info("Start recording");
      recordingStart = true;
      $("#recording").addClass("red");
      $("#recording p").html("Stop Recording");
      startRecording();
    } else {
      toastr.info("Terminate registration");
      recordingStart = false;
      $("#recording").removeClass("red");
      $("#recording p").html("Start Recording");
      stopRecording();
    }
  });

  function startRecording() {
    if (
      user_sharing_screen === -1 &&
      user_speaking_show !== ".localVideoContainer"
    ) {
      arrayOfStreams_recording = arrayOfStreams;
    }

    multiStreamRecorder = new MultiStreamRecorder(arrayOfStreams_recording, {
      mimeType: "video/webm",
      video: {
        width: 1920,
        height: 1080,
      },
    });
    multiStreamRecorder.record();
  }

  function stopRecording() {
    multiStreamRecorder.stop(function (blob) {
      downloadRecording(blob);
    });
  }

  function downloadRecording(blob) {
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.style.display = "none";
    a.href = url;
    a.download = "test.webm";
    document.body.appendChild(a);
    a.click();
    setTimeout(() => {
      document.body.removeChild(a);
      window.URL.revokeObjectURL(url);
    }, 100);
  }

  function postVideoToServer(videoblob) {
    /*  var x = new XMLHttpRequest();
            x.open('POST', 'uploadMessage');
            x.send(videoblob);
        */
    var data = {};
    constraints.log(videoblob);
    data.video = videoblob;
    data.metadata = "test metadata";
    data.action = "upload_video";
    // jQuery.post("http://www.foundthru.co.uk/uploadvideo.php", data, onUploadSuccess);
  }

  //initiate meeting
  function init() {
    $(".meeting-details, .navbar, footer").hide();
    $("#updateLayouts").remove();
    // $('#openChat').remove();
    $(".meeting-section").show();
    $(".local-user-name").text(userInfo.username);
    if (!watching) {
      localVideo.srcObject = localStream;
    } else {
      localVideo.srcObject = localStream;
      $(".localVideoContainer").hide();
      localStream.getAudioTracks().forEach((track) => {
        track.enabled = false;
      });
      micMuted = true;
      localStream.getVideoTracks().forEach((track) => {
        track.enabled = false;
      });
      videoMuted = true;
    }

    layout();
    sendMessage({
      type: "join",
      username: userInfo.username,
      meetingId: userInfo.meetingId,
      moderator: isModerator,
      watch: watching,
    });
    if (limitedTimeMeeting) {
      //start with a time limit for limited time meeting
      timer.start({
        precision: "seconds",
        startValues: { seconds: 0 },
        target: { seconds: settings.timeLimit * 60 - 60 },
      });
    } else {
      //start with no time limit
      timer.start({ precision: "seconds", startValues: { seconds: 0 } });
    }
    manageOptions();
    // if (!watching) {
    if (isMobile && meetingType === "video") {
      $("#toggleCam").show();
    }
    // else {
    //     $('#toggleCam').show();
    // }

    if (!isMobile) $(".updateDevices").show();
    // initKeyShortcuts();
    if (!localStorage.getItem("tripDone")) {
      setTimeout(function () {
        showInfo("Double click on the video to make it full screen!");
        // showInfo('Single click on the video to turn picture-in-picture mode on.');
        localStorage.setItem("tripDone", true);
      }, 3000);
    }
    // }
  }

  //hide/show certain meeting related details
  function manageOptions() {
    $(".meeting-options").show();
    $("#meetingIdInfo").html(userInfo.meetingTitle);
    localStorage.setItem("videoQuality", videoQualitySelect.value);

    if (meetingType === "video") {
      $("#toggleVideo").show();
    }
    // else {
    //     $('#toggleVideo').show();
    // }

    setTimeout(function () {
      hideOptions();
    }, 3000);

    $("body").mousemove(function () {
      showOptions();
    });
  }

  //hide meeting ID and options
  function hideOptions() {
    $(
      ".meeting-options, .local-user-name, .remote-user-name, .meeting-info, .kick, .full-screen"
    ).hide();
  }

  //show meeting ID and options
  function showOptions() {
    $(
      ".meeting-options, .local-user-name, .remote-user-name, .meeting-info, .kick, .full-screen"
    ).show();

    if (mouseMoveTimer) {
      clearTimeout(mouseMoveTimer);
    }

    mouseMoveTimer = setTimeout(function () {
      hideOptions();
    }, 3000);
  }

  //create and send an offer for newly joined user
  function handleJoin(data) {
    usernames[data.socketId] = {
      username: data.username,
      micMuted: data.micMuted,
      watch: data.watch,
      videoMuted: data.videoMuted,
    };
    refreshMemnbers();

    //initialize a new connection
    let connection = new RTCPeerConnection(configuration);
    connections[data.socketId] = connection;

    setupListeners(connection, data.socketId, data.uuid, data.watch);

    connection
      .createOffer({
        offerToReceiveVideo: true,
      })
      .then(function (offer) {
        return connection.setLocalDescription(offer);
      })
      .then(function () {
        console.log({
          type: "offer",
          sdp: connection.localDescription,
          username: userInfo.username,
          fromSocketId: socket.id,
          toSocketId: data.socketId,
          uuid: userInfo.uuid,
          watch: watching,
          micMuted: micMuted,
          videoMuted: videoMuted,
        });
        sendMessage({
          type: "offer",
          sdp: connection.localDescription,
          username: userInfo.username,
          fromSocketId: socket.id,
          toSocketId: data.socketId,
          uuid: userInfo.uuid,
          watch: watching,
          micMuted: micMuted,
          videoMuted: videoMuted,
        });
      })
      .catch(function (e) {
        console.log("An error occurred: ", e);
      });
  }

  function refreshMemnbers() {
    $(".members-body").empty();

    var watching_count = 1;
    $(".members-body").append(
      "" +
        '<div class="member">\n' +
        "<span>" +
        userInfo.username +
        "</span>" +
        '<a class="member-btn plus">(You)</a></div>'
    );

    Object.keys(usernames).forEach((socketId, index, array) => {
      watching_count += 1;
      if (isModerator) {
        var str = "";
        str +=
          '<div class="member">\n' +
          "<span>" +
          usernames[socketId].username +
          "</span>\n";

        str +=
          '<a href="#" data-id="' +
          socketId +
          '" class="member-btn kick_off"><i class="fa fa-ban"></i></a>';

        if (!usernames[socketId].micMuted) {
          str +=
            '<a href="#" data-id="' +
            socketId +
            '" class="member-btn volume_off"><i class="fa fa-volume-up"></i></a>';
        } else {
          str +=
            '<a href="#" data-id="' +
            socketId +
            '" class="member-btn volume_up"><i class="fa fa-volume-off"></i></a>';
        }

        if (usernames[socketId].watch) {
          str +=
            '<a href="#" data-id="' +
            socketId +
            '" class="member-btn plus"><i class="fa fa-plus"></i></a>';
        } else {
          str +=
            '<a href="#" data-id="' +
            socketId +
            '" class="member-btn minus"><i class="fa fa-minus"></i></a>';
        }
        str += "</div>";

        $(".members-body").append(str);
      } else {
        $(".members-body").append(
          "" +
            '<div class="member">\n' +
            "<span>" +
            usernames[socketId].username +
            "</span></div>"
        );
      }
    });

    $("#participants").html(watching_count);
  }

  //handle offer from initiator, create and send an answer
  function handleOffer(data) {
    usernames[data.fromSocketId] = {
      username: data.username,
      micMuted: data.micMuted,
      watch: data.watch,
      videoMuted: data.videoMuted,
    };
    refreshMemnbers();

    //initialize a new connection
    let connection = new RTCPeerConnection(configuration);
    connections[data.fromSocketId] = connection;

    connection.setRemoteDescription(data.sdp);
    setupListeners(connection, data.fromSocketId, data.uuid, data.watch);

    connection
      .createAnswer()
      .then(function (answer) {
        setDescriptionAndSendAnswer(answer, data.fromSocketId);
      })
      .catch(function (e) {
        console.log(e);
      });
  }

  //set local description and send the answer
  function setDescriptionAndSendAnswer(answer, fromSocketId) {
    connections[fromSocketId].setLocalDescription(answer);
    sendMessage({
      type: "answer",
      answer: answer,
      fromSocketId: socket.id,
      toSocketId: fromSocketId,
    });
  }

  //handle answer and set remote description
  function handleAnswer(data) {
    let currentConnection = connections[data.fromSocketId];
    if (currentConnection) {
      currentConnection.setRemoteDescription(data.answer);
    }
  }

  //handle candidate and add ice candidate
  function handleCandidate(data) {
    let currentConnection = connections[data.fromSocketId];
    if (data.candidate && currentConnection) {
      currentConnection.addIceCandidate(new RTCIceCandidate(data.candidate));
    }
  }

  //change the video size on window resize
  window.onresize = function () {
    clearTimeout(resizeTimeout);
    resizeTimeout = setTimeout(function () {
      layout();
    }, 20);
  };

  //add local track to the connection,
  //manage remote track,
  //ice candidate and state change event
  function setupListeners(connection, socketId, opponentUuid, watch) {
    try {
      localStream
        .getTracks()
        .forEach((track) => connection.addTrack(track, localStream));
    } catch (e) {}

    connection.onicecandidate = (event) => {
      if (event.candidate) {
        sendMessage({
          type: "candidate",
          candidate: event.candidate,
          fromSocketId: socket.id,
          toSocketId: socketId,
        });
      }
    };

    connection.ontrack = (event) => {
      // if () {
      if (document.getElementById("video-" + socketId)) {
        return;
      }
      events[socketId] = event;
      setUpRemoteVideo(event, socketId, opponentUuid, watch);
      // }
    };

    connection.addEventListener("connectionstatechange", () => {
      if (connection.connectionState === "connected") {
        if (!isMobile) $("#screenShare").show();
        if (usernames[socketId]) {
          showSuccess(usernames[socketId].username + " Joined the meeting.");
        }
        if (isModerator) {
          sendMessage({
            type: "currentTime",
            currentTime:
              timer.getTimeValues().minutes * 60 +
              timer.getTimeValues().seconds,
            fromSocketId: socket.id,
            toSocketId: socketId,
          });
        }
      }
    });
  }

  function setUpRemoteVideo(event, socketId, opponentUuid, remove) {
    if (event != undefined && !usernames[socketId].watch) {
      let videoRemote = document.createElement("video");
      videoRemote.id = "video-" + socketId;
      videoRemote.setAttribute("autoplay", "");
      videoRemote.setAttribute("playsinline", "");
      videoRemote.srcObject = event.streams[0];

      if (arrayOfStreams.indexOf(event.streams[0]) === -1) {
        arrayOfStreams.push(event.streams[0]);
        arrayOfStreams_ids.push(socketId);

        if (multiStreamRecorder != undefined) {
          multiStreamRecorder.addStreams(event.streams[0]);
        }
      }

      videoRemote.onloadedmetadata = function (e) {
        videoRemote.play();
      };

      let containerDiv = document.createElement("div");
      containerDiv.id = "container-" + socketId;
      containerDiv.className = "videoContainer";

      let containerText = document.createElement("span");
      containerText.className = "remote-user-name";
      containerText.innerText = usernames[socketId].username;

      if (isModerator && settings.moderatorRights == "enabled") {
        let kickButton = document.createElement("button");
        kickButton.className = "btn meeting-option kick";
        kickButton.innerHTML = '<i class="fa fa-ban"></i>';
        kickButton.setAttribute("data-id", socketId);
        kickButton.setAttribute("title", "Kick this user");
        containerDiv.appendChild(kickButton);
      }

      let fullButton = document.createElement("button");
      fullButton.className = "btn meeting-option full-screen";
      fullButton.innerHTML = '<i class="fa fa-expand"></i>';
      fullButton.setAttribute("data-id", socketId);
      fullButton.setAttribute("title", "Full Screen");
      containerDiv.appendChild(fullButton);

      containerDiv.appendChild(videoRemote);
      containerDiv.appendChild(containerText);
      videos.appendChild(containerDiv);

      layout();
    } else {
      if (event) {
        var containerDiv = document.getElementById("container-" + socketId);
        if (arrayOfStreams.indexOf(event.streams[0]) > -1) {
          arrayOfStreams.splice(arrayOfStreams.indexOf(event.streams[0]), 1);
          arrayOfStreams_ids.splice(arrayOfStreams_ids.indexOf(socketId), 1);
        }
        // multiStreamRecorder.removeStreams(event.streams[0]);
        if (containerDiv) {
          containerDiv.remove();
          layout();
        }
      }
    }
  }

  //kick the participant out of the meeting
  $(document).on("click", ".kick", function () {
    if (confirm("Are you sure you want to kick this user?")) {
      $(this).attr("disabled", true);
      sendMessage({
        type: "kick",
        toSocketId: $(this).data("id"),
      });
    }
  });

  $(document).on("click", ".kick_off", function () {
    if (confirm("Are you sure you want to kick this user?")) {
      $(this).attr("disabled", true);
      sendMessage({
        type: "kick",
        toSocketId: $(this).data("id"),
      });
    }
  });

  $(document).on("click", ".volume_off", function () {
    if (confirm("Are you sure you want to mute this user?")) {
      usernames[$(this).data("id")].micMuted = true;
      refreshMemnbers();
      sendMessage({
        type: "micChanged",
        micMuted: true,
        socket_id: $(this).data("id"),
        username: userInfo.username,
      });
      sendMessage({
        type: "mute",
        toSocketId: $(this).data("id"),
      });
    }
  });

  $(document).on("click", ".volume_up", function () {
    if (confirm("Are you sure you want to unmute this user?")) {
      usernames[$(this).data("id")].micMuted = false;
      refreshMemnbers();
      sendMessage({
        type: "micChanged",
        micMuted: false,
        socket_id: $(this).data("id"),
        username: userInfo.username,
      });
      sendMessage({
        type: "volume_up",
        toSocketId: $(this).data("id"),
      });
    }
  });

  $(document).on("click", ".plus", function () {
    if (confirm("Are you sure you want to add this user to the meeting?")) {
      usernames[$(this).data("id")].watch = false;
      refreshMemnbers();
      setUpRemoteVideo(
        events[$(this).data("id")],
        $(this).data("id"),
        null,
        false
      );
      sendMessage({
        type: "removeWatch",
        watch: false,
        socket_id: $(this).data("id"),
        username: userInfo.username,
      });
    }
  });

  $(document).on("click", ".minus", function () {
    if (confirm("Are you sure you want to pause this user from the meeting?")) {
      usernames[$(this).data("id")].watch = true;
      refreshMemnbers();
      setUpRemoteVideo(
        events[$(this).data("id")],
        $(this).data("id"),
        null,
        true
      );
      sendMessage({
        type: "removeWatch",
        watch: true,
        socket_id: $(this).data("id"),
        username: userInfo.username,
      });
    }
  });

  //handle when opponent leaves the meeting
  function handleLeave(data) {
    if (usernames[data.fromSocketId]) {
      showInfo(usernames[data.fromSocketId].username + " He left the meeting");
    }

    if (data.isModerator) {
      reload(1);
    }

    let video = document.getElementById("video-" + data.fromSocketId);
    let container = document.getElementById("container-" + data.fromSocketId);

    if (video && container) {
      video.pause();
      video.srcObject = null;
      video.load();
      container.removeChild(video);
      videos.removeChild(container);
      layout();
    }

    //remove record stream
    var index_of_stream = arrayOfStreams_ids.indexOf(data.fromSocketId);
    arrayOfStreams.splice(index_of_stream, 1);
    arrayOfStreams_ids.splice(index_of_stream, 1);
    usernames.splice(data.fromSocketId, 1);
    var temp_usernames = [];
    for (var k in usernames) {
      if (k !== data.fromSocketId) {
        temp_usernames[k] = usernames[k];
      }
    }
    usernames = temp_usernames;
    refreshMemnbers();

    let currentConnection = connections[data.fromSocketId];

    if (currentConnection) {
      currentConnection.close();
      currentConnection.onicecandidate = null;
      currentConnection.ontrack = null;
      delete connections[data.fromSocketId];
    }
    // usernames = usernames.splice(data.fromSocketId, 1);
  }

  //mute/unmute local video
  $(document).on("click", "#toggleVideo", function () {
    if (videoMuted) {
      localStream.getVideoTracks().forEach((track) => (track.enabled = true));
      $(this).html('<i class="fa fa-video"></i>').addClass("green");
      videoMuted = false;
      showSuccess("The camera is turned on.");
    } else {
      localStream.getVideoTracks().forEach((track) => (track.enabled = false));
      $(this).html('<i class="fa fa-video-slash"></i>').removeClass("green");
      videoMuted = true;
      showSuccess("The camera is turned off.");
    }
  });

  function stopMic(attr) {
    sendMessage({
      type: "micChanged",
      micMuted: !micMuted,
      socket_id: socket.id,
      username: userInfo.username,
    });
    if (micMuted) {
      localStream.getAudioTracks().forEach((track) => (track.enabled = true));
      $(attr).html('<i class="fa fa-microphone"></i>').addClass("green");

      micMuted = false;
      showSuccess("The sound has been played");
    } else {
      localStream.getAudioTracks().forEach((track) => (track.enabled = false));
      $(attr)
        .html('<i class="fa fa-microphone-slash"></i>')
        .removeClass("green");

      micMuted = true;
      showSuccess("The sound is muted");
    }
  }

  //mute/unmute local audio
  $(document).on("click", "#toggleMic", function () {
    stopMic(this);
  });

  //leave the meeting
  $(document).on("click", "#leave", function () {
    // showError('The meeting is over!');
    reload(0);
  });

  //switch front/back camera for mobile users
  $(document).on("click", "#toggleCam", function () {
    localStream.getVideoTracks().forEach((track) => track.stop());
    try {
      localStream.removeTrack(localStream.getVideoTracks()[0]);
      facingMode = facingMode === "user" ? "environment" : "user";

      navigator.mediaDevices
        .getUserMedia({
          video: {
            facingMode: {
              exact: facingMode,
            },
          },
        })
        .then(function (stream) {
          let videoTrack = stream.getVideoTracks()[0];
          localStream.addTrack(videoTrack);

          Object.values(connections).forEach((connection) => {
            let sender = connection.getSenders().find(function (s) {
              return s.track.kind === videoTrack.kind;
            });

            sender.replaceTrack(videoTrack);
          });
        })
        .catch(function () {
          // showError();
        });
    } catch (e) {}
  });

  //warn the user if he tries to leave the page during the meeting
  window.onbeforeunload = function () {
    socket.close();
    Object.keys(connections).forEach((key) => {
      connections[key].close();
      let video = document.getElementById("video-" + key);
      if (video) {
        video.pause();
        video.srcObject = null;
        video.load();
        video.parentNode.removeChild(video);
      }
    });
  };

  //enter into fullscreen mode with double click on video
  $(document).on("dblclick", "video", function () {
    if (this.readyState === 4 && this.srcObject.getVideoTracks().length) {
      try {
        this.requestFullscreen();
      } catch (e) {
        showError("Full screen mode is not supported in this browser.");
      }
    } else {
      showError("The video does not play or does not contain a video track.");
    }
  });

  $(document).on("click", ".full-screen", function () {
    let video = document.getElementById("video-" + $(this).attr("data-id"));
    try {
      video.requestFullscreen();
    } catch (e) {
      showError("Full screen mode is not supported in this browser.");
    }
  });

  //toggle chat panel
  $(document).on("click", "#openChat", function () {
    $(".chat-panel").animate({
      width: "toggle",
    });

    if ($(this).hasClass("notify")) $(this).removeClass("notify");
  });

  $(document).on("click", "#openMembers", function () {
    $(".members-panel").animate({
      width: "toggle",
    });

    if ($(this).hasClass("notify")) $(this).removeClass("notify");
  });

  //close chat panel
  $(document).on("click", ".close-panel", function () {
    $(".chat-panel").animate({
      width: "toggle",
    });
  });

  $(document).on("click", ".close-members-panel", function () {
    $(".members-panel").animate({
      width: "toggle",
    });
  });

  //copy/share the meeting invitation
  $(document).on("click", "#add", function () {
    let link = location.protocol + "//" + location.host + location.pathname;

    if (navigator.share) {
      try {
        navigator.share({
          title: settings.appName,
          url: link,
          text: inviteMessage,
        });
      } catch (e) {
        showError(e);
      }
    } else {
      let inp = document.createElement("textarea");
      inp.style.display = "hidden";
      document.body.appendChild(inp);
      inp.value = inviteMessage + link;
      inp.select();
      document.execCommand("copy", false);
      inp.remove();
      showSuccess("Meeting invite link copied to clipboard!");
    }
  });

  //listen for message form submit event and send message
  $(document).on("submit", "#chatForm", function (e) {
    e.preventDefault();

    let message = $("#messageInput").val().trim();

    if (message) {
      $("#messageInput").val("");
      appendMessage(message, null, true);

      sendMessage({
        type: "meetingMessage",
        message: message,
        username: userInfo.username,
      });
    }
  });

  //handle message and append it
  function handlemeetingMessage(data) {
    if ($(".chat-panel").is(":hidden") && !watching) {
      $("#openChat").addClass("notify");
      showOptions();
      notificationTone.play();
    }
    appendMessage(data.message, data.username, false);
  }

  function handlemicChanged(data) {
    if (usernames[data.socket_id]) {
      usernames[data.socket_id].micMuted = data.micMuted;
      refreshMemnbers();
    }
  }

  function handlRemoveWatch(data) {
    if (data.socket_id != socket.id) {
      usernames[data.socket_id].watch = data.watch;
      refreshMemnbers();
      setUpRemoteVideo(events[data.socket_id], data.socket_id, null, true);
    } else {
      if (data.watch) {
        setToWatching();
      } else {
        removeWatching();
      }
    }
  }

  //append message to chat body
  function appendMessage(message, username, self) {
    if ($(".empty-chat-body")) {
      $(".empty-chat-body").remove();
    }

    let className = self ? "local-chat" : "remote-chat",
      messageDiv =
        '<div class="' +
        className +
        '">' +
        "<div>" +
        (username
          ? '<span class="remote-chat-name">' + username + ": </span>"
          : "") +
        linkify(message) +
        "</div>" +
        "</div>";

    if (self || (!self && !watching)) {
      $(".chat-body").append(messageDiv);
      $(".chat-body").animate(
        {
          scrollTop: $(".chat-body").prop("scrollHeight"),
        },
        1000
      );
    }
  }

  //toggle screen share
  $(document).on("click", "#screenShare", function () {
    if (screenShared) {
      stopScreenSharing();
    } else {
      startScreenSharing();
    }
  });

  //stop screen share
  function stopScreenSharing() {
    localStream.getVideoTracks().forEach((track) => track.stop());
    localStream.removeTrack(localStream.getVideoTracks()[0]);
    screenStream = null;
    replaceVideoTrack(localVideoTrack);
    screenShared = false;
    user_sharing_screen = -1;

    arrayOfStreams_recording = [];
    user_speaking_show = -1;
    $("#videos div").removeClass("hide");
    layout();

    // var index_of_stream = arrayOfStreams_ids.indexOf('screen_share');
    // arrayOfStreams.splice(index_of_stream, 1);
    // arrayOfStreams_ids.splice(index_of_stream, 1);
    // console.log(arrayOfStreams);
    // console.log(arrayOfStreams_ids);
  }

  //start screensharing
  async function startScreenSharing() {
    user_sharing_screen = ".localVideoContainer";
    if (user_sharing_screen != -1) {
      $("#videos div").addClass("hide");
      $(user_sharing_screen).removeClass("hide");
      layout();
    }

    if (meetingType === "audio") {
      showError("Please join with a cam to use the screen sharing feature.");
      return;
    }

    let displayMediaOptions = {
      video: {
        cursor: "always",
        width: { ideal: 1920, max: 1920 },
        height: { ideal: 1080, max: 1080 },
      },
      audio: false,
    };

    try {
      screenStream = await navigator.mediaDevices.getDisplayMedia(
        displayMediaOptions
      );
    } catch (e) {
      user_speaking_show = -1;
      $("#videos div").removeClass("hide");
      layout();
      showError(
        "Unable to share screen, please check permissions and try again."
      );
    }

    if (screenStream) {
      screenShared = true;

      localVideoTrack = localStream.getVideoTracks()[0];
      localStream.removeTrack(localStream.getVideoTracks()[0]);
      replaceVideoTrack(screenStream.getVideoTracks()[0]);

      $("#localVideo").attr(
        "style",
        "-webkit-transform: scaleX(1) !important;transform:scaleX(1) !important"
      );
      sendMessage({
        type: "screenSharing",
        socket_id: socket.id,
        start: "started",
      });

      screenStream.getVideoTracks()[0].addEventListener("ended", () => {
        stopScreenSharing();
        $("#localVideo").attr(
          "style",
          "-webkit-transform: scaleX(-1) !important;transform:scaleX(-1) !important"
        );
        sendMessage({
          type: "screenSharing",
          socket_id: socket.id,
          start: "stopped",
        });
        // $('#localVideo').css({
        //     "-webkit-transform": scaleX(-1),
        //     "transform": scaleX(-1)
        // });
      });

      arrayOfStreams_recording = [localStream];
    }
  }

  //replace video track and add track to the localStream
  function replaceVideoTrack(videoTrack) {
    localStream.addTrack(videoTrack);

    Object.values(connections).forEach((connection) => {
      let sender = connection.getSenders().find(function (s) {
        return s.track.kind === videoTrack.kind;
      });

      sender.replaceTrack(videoTrack);
    });
  }

  //listen on file input change
  $("#file").on("change", function () {
    let inputFile = this.files;
    let maxFilesize = $(this).data("max");

    if (inputFile && inputFile[0]) {
      if (inputFile[0].size > maxFilesize * 1024 * 1024) {
        showError("The maximum allowed file size is " + maxFilesize + "MB.");
        return;
      }

      $("#previewImage").attr("src", "images/loader.gif");
      $("#previewFilename").text(inputFile[0].name);
      $("#previewModal").modal("show");

      if (inputFile[0].type.includes("image")) {
        let reader = new FileReader();
        reader.onload = function (e) {
          $("#previewImage").attr("src", e.target.result);
        };
        reader.readAsDataURL(inputFile[0]);
      } else {
        $("#previewImage").attr("src", "/images/file.png");
      }
    } else {
      // showError();
    }
  });

  //empty file value on modal close
  $("#previewModal").on("hidden.bs.modal", function () {
    $("#file").val("");
  });

  //hide modal on file send button click
  $(document).on("click", "#sendFile", function () {
    $("#previewModal").modal("hide");
  });

  //append file to the chat panel
  function appendFile(file, extension, username, self) {
    if ($(".empty-chat-body")) {
      $(".empty-chat-body").remove();
    }

    let remoteUsername = username ? "<span>" + username + ": </span>" : "";

    let className = self ? "local-chat" : "remote-chat",
      fileDiv =
        "<div class='" +
        className +
        "'>" +
        "<button class='btn btn-primary fileMessage' title='View File' data-file='" +
        file +
        "' data-extension='" +
        extension +
        "'>" +
        remoteUsername +
        "<i class='fa fa-file'></i></button>";

    if (self || (!self && !watching)) {
      $(".chat-body").append(fileDiv);
      $(".chat-body").animate(
        {
          scrollTop: $(".chat-body").prop("scrollHeight"),
        },
        1000
      );
    }
  }

  //dispay file on button click
  $(document).on("click", ".fileMessage", function () {
    let filename = $(this).data("file");
    let extension = $(this).data("extension");

    $("#displayImage").attr("src", "/images/loader.gif");
    $("#displayFilename").text(filename + extension);
    $("#displayModal").modal("show");

    fetch("/file_uploads/" + userInfo.meetingId + "/" + filename + extension)
      .then((res) => res.blob())
      .then((blob) => {
        displayFileUrl = window.URL.createObjectURL(blob);
        if ([".png", ".jpg", ".jpeg", ".gif"].includes(extension)) {
          $("#displayImage").attr("src", displayFileUrl);
        } else {
          $("#displayImage").attr("src", "/images/file.png");
        }
      })
      .catch(() => showError());
  });

  //download file on button click
  $(document).on("click", "#downloadFile", function () {
    const link = document.createElement("a");
    link.style.display = "none";
    link.href = displayFileUrl;
    link.download = $("#displayFilename").text();
    document.body.appendChild(link);
    link.click();
    $("#displayModal").modal("hide");
    window.URL.revokeObjectURL(displayFileUrl);
  });

  //open file exploler
  $(document).on("click", "#selectFile", function () {
    $("#file").trigger("click");
  });

  //open device settings modal
  $(".updateDevices").on("click", function () {
    $("#deviceSettings").modal("show");
    getDevices();
  });

  $(".updateLayout").on("click", function () {
    user_speaking_show = -1;
    $("#updateLayout").modal("show");
  });

  $("#showAllBtn").on("click", function () {
    user_speaking_show = -1;
    $("#videos div").removeClass("hide");
    layout();
  });

  $("#showSpeakerBtn").on("click", function () {
    user_speaking_show = 1;
  });

  $("#showShareScreenBtn").on("click", function () {
    if (user_sharing_screen != -1) {
      $("#videos div").addClass("hide");
      $(user_sharing_screen).removeClass("hide");
      layout();
    } else {
      showError("Nobody shares the screen yet!");
    }
  });

  //call getUserMedia
  function getDevices() {
    const constraints = {
      audio: getAudioConstraints(),
      video: getVideoConstraints(),
    };

    navigator.mediaDevices
      .getUserMedia(constraints)
      .then(gotStream)
      .then(gotDevices)
      .catch(() => showError());
  }

  //handle got stream
  function gotStream(stream) {
    window.stream = stream;
    return navigator.mediaDevices.enumerateDevices();
  }

  //set devices in select input
  function gotDevices(deviceInfos) {
    const values = selectors.map((select) => select.value);
    selectors.forEach((select) => {
      while (select.firstChild) {
        select.removeChild(select.firstChild);
      }
    });
    for (let i = 0; i !== deviceInfos.length; ++i) {
      const deviceInfo = deviceInfos[i];
      const option = document.createElement("option");
      option.value = deviceInfo.deviceId;
      if (deviceInfo.kind === "audioinput") {
        option.text =
          deviceInfo.label || `microphone ${audioInputSelect.length + 1}`;
        audioInputSelect.appendChild(option);
      } else if (deviceInfo.kind === "videoinput") {
        option.text =
          deviceInfo.label || `camera ${videoInputSelect.length + 1}`;
        videoInputSelect.appendChild(option);
      }
    }
    selectors.forEach((select, selectorIndex) => {
      if (
        Array.prototype.slice
          .call(select.childNodes)
          .some((n) => n.value === values[selectorIndex])
      ) {
        select.value = values[selectorIndex];
      }
    });

    window.stream.getTracks().forEach((track) => {
      track.stop();
    });
  }

  //get audio constraints
  function getAudioConstraints() {
    const audioSource = audioInputSelect.value;

    return {
      deviceId: audioSource ? { exact: audioSource } : undefined,
    };
  }

  //get video constraints
  function getVideoConstraints() {
    // if (muteCamera.checked) {
    //     return false;
    // } else {
    return {
      deviceId: videoInputSelect.value,
      width: { exact: $("#" + videoQualitySelect.value).data("width") },
      height: { exact: $("#" + videoQualitySelect.value).data("height") },
    };
    // }
  }

  //video input change handler
  videoQualitySelect.onchange = videoInputSelect.onchange = async function () {
    if (!localStream) return;

    constraints = {
      video: getVideoConstraints(),
    };

    try {
      localStream.getVideoTracks().forEach((track) => track.stop());
      let videoStream = await navigator.mediaDevices.getUserMedia(constraints);
      localStream.removeTrack(localStream.getVideoTracks()[0]);
      replaceMediaTrack(videoStream.getVideoTracks()[0]);
      videoSource.value = localStream
        .getVideoTracks()[0]
        .getSettings().deviceId;
      localStorage.setItem("videoQuality", videoQualitySelect.value);
    } catch (e) {
      // console.log('Could not get the devices, please check the permissions and try again. Error: ' + e);
    }
  };

  //checks and audio input change handler
  audioSource.onchange = async function () {
    if (!localStream) return;

    constraints = {
      audio: getAudioConstraints(),
    };

    try {
      localStream.getAudioTracks().forEach((track) => track.stop());
      let audioStream = await navigator.mediaDevices.getUserMedia(constraints);
      localStream.removeTrack(localStream.getAudioTracks()[0]);
      replaceMediaTrack(audioStream.getAudioTracks()[0]);
    } catch (e) {
      // console.log('Could not get the devices, please check the permissions and try again. Error: ' + e.name);
    }
  };

  //replace video track and add track to the localStream
  function replaceMediaTrack(track) {
    if (localStream) localStream.addTrack(track);

    Object.values(connections).forEach((connection) => {
      let sender = connection.getSenders().find(function (s) {
        return s.track.kind === track.kind;
      });

      sender.replaceTrack(track);
    });
  }

  //detect and replace text with url
  function linkify(text) {
    var urlRegex =
      /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/gi;
    return text.replace(urlRegex, function (url) {
      return '<a href="' + url + '" target="_blank">' + url + "</a>";
    });
  }

  //initiate keyboard shortcuts
  function initKeyShortcuts() {
    $(document).on("keydown", function () {
      if ($("#messageInput").is(":focus")) return;

      switch (event.key) {
        case "C":
        case "c":
          $(".chat-panel").animate({
            width: "toggle",
          });
          break;
        case "F":
        case "f":
          if ($(".chat-panel").is(":hidden")) {
            $(".chat-panel").animate({
              width: "toggle",
            });
          }
          $("#selectFile").trigger("click");
          break;
        case "A":
        case "a":
          $("#toggleMic").trigger("click");
          break;
        case "L":
        case "l":
          $("#leave").trigger("click");
          break;
        case "V":
        case "v":
          if (meetingType === "video") $("#toggleVideo").trigger("click");
          break;
        case "S":
        case "s":
          if (initializedOnce) $("#screenShare").trigger("click");
          break;
      }
    });
  }

  const listVideo = document.querySelector("#list-video");
  if (listVideo) {
    listVideo.addEventListener("click", () => {
      if (listVideo.src.includes("video-white.svg")) {
        listVideo.src = url + "/assets/new-live/icons/video-disabled-white.svg";
        listVideo.style.backgroundColor = "#A3A3A3";
        // containerWithImage.style.display = "none"
        // mainContainerImage.style.display = ""
      } else {
        listVideo.src = url + "/assets/new-live/icons/video-white.svg";
        listVideo.style.backgroundColor = "#01BC62";
        // containerWithImage.style.display = ""
        // mainContainerImage.style.display = "none"
      }
    });
  }

  const toggleMic = () => {
    if (listMic.src.includes("mic-white.svg")) {
      listMic.src = url + "/assets/new-live/icons/mic-muted-white.svg";
      listMic.style.backgroundColor = "#A3A3A3";
      videoMic.style.display = "block";
      // videoWithImageMic.style.display = "block"
    } else {
      listMic.src = url + "/assets/new-live/icons/mic-white.svg";
      listMic.style.backgroundColor = "#01BC62";
      videoMic.style.display = "none";
      // videoWithImageMic.style.display = "none"
    }
  };

  const listMic = document.querySelector("#list-mic");
  const videoWithImageMic = document.querySelector("#video-with-image-mic");
  const videoMic = document.querySelector("#video-mic");

  if (videoMic) {
    videoMic.addEventListener("click", toggleMic);
  }
  if (videoWithImageMic) {
    videoWithImageMic.addEventListener("click", toggleMic);
  }
  if (listMic) {
    listMic.addEventListener("click", toggleMic);
  }

  let fullScreenButton = document.querySelector("#fullscreen_btn");
  function cancelFullScreen() {
    var el = document;
    var requestMethod =
      el.cancelFullScreen ||
      el.webkitCancelFullScreen ||
      el.mozCancelFullScreen ||
      el.exitFullscreen ||
      el.webkitExitFullscreen;
    if (requestMethod) {
      // cancel full screen.
      requestMethod.call(el);
    } else if (typeof window.ActiveXObject !== "undefined") {
      // Older IE.
      var wscript = new ActiveXObject("WScript.Shell");
      if (wscript !== null) {
        wscript.SendKeys("{F11}");
      }
    }
  }

  function requestFullScreen(el) {
    // Supports most browsers and their versions.
    var requestMethod =
      el.requestFullScreen ||
      el.webkitRequestFullScreen ||
      el.mozRequestFullScreen ||
      el.msRequestFullscreen;

    if (requestMethod) {
      // Native full screen.
      requestMethod.call(el);
    } else if (typeof window.ActiveXObject !== "undefined") {
      // Older IE.
      var wscript = new ActiveXObject("WScript.Shell");
      if (wscript !== null) {
        wscript.SendKeys("{F11}");
      }
    }
    return false;
  }
  if (fullScreenButton) {
    fullScreenButton.addEventListener("click", () => {
      var el = document.body; // Make the body go full screen.
      var isInFullScreen =
        (document.fullScreenElement && document.fullScreenElement !== null) ||
        document.mozFullScreen ||
        document.webkitIsFullScreen;

      if (isInFullScreen) {
        cancelFullScreen();
      } else {
        requestFullScreen(el);
      }
      return false;
    });
  }
})();
