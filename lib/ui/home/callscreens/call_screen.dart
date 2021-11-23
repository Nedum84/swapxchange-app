import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/models/app_user.dart';
import 'package:swapxchange/models/call.dart';
import 'package:swapxchange/repository/call_methods.dart';
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';

class CallScreen extends StatefulWidget {
  final Call call;
  final ClientRole clientRole; //ClientRole.Broadcaster;

  CallScreen({required this.call, required this.clientRole});

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final CallMethods callMethods = CallMethods();
  AppUser? currentUser = UserController.to.user;

  StreamSubscription? callStreamSubscription;
  RtcEngine? _engine;

  int? _remoteUid;
  final _infoStrings = <String>[];
  bool muted = false;

  @override
  void initState() {
    super.initState();
    addPostFrameCallback();
    initializeAgora();
  }

  @override
  void dispose() {
    // clear users
    _remoteUid = null;
    callMethods.endCall(call: widget.call);
    _engine?.leaveChannel();
    _engine?.destroy();
    callStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> initializeAgora() async {
    await _initAgoraRtcEngine();
    this._addAgoraEventHandlers();
    // await _engine?.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = VideoDimensions(
      width: 1920,
      height: 1080,
    );
    // await _engine?.setParameters('''{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');
    await _engine?.setVideoEncoderConfiguration(configuration);
    await _engine?.joinChannel(widget.call.callToken, widget.call.channelId!, null, int.tryParse(currentUser!.userId!) ?? 0);
    // await _engine?.joinChannel(widget.call.callToken, widget.call.channelId!, null, widget.call.callUid!);
  }

  addPostFrameCallback() {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      // snapshot is null which means that call is hanged and documents are deleted
      callStreamSubscription = callMethods.callStream(uid: currentUser!.uid!).listen((DocumentSnapshot ds) async {
        if (ds.data() == null || (ds.data()! as Map<String, dynamic>).isEmpty) {
          AlertUtils.toast('Call ended.');
          if (this.mounted) Get.back();
        }
      });
    });
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.createWithConfig(RtcEngineConfig(Constants.AGORA_APP_ID));
    if (widget.call.useVideo!) {
      await _engine?.enableVideo();
    } else {
      await _engine?.disableVideo();
    }
    await _engine?.enableAudio();
    await _engine?.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine?.setClientRole(ClientRole.Broadcaster);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine?.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          _infoStrings.add("You initiated this call");
        },
        userJoined: (int uid, int elapsed) {
          _infoStrings.add("Remote user joined");
          callMethods.markMissedCall(call: widget.call, isMissedCall: false);
          setState(() {
            _remoteUid = uid;
          });
        },
        userOffline: (int uid, UserOfflineReason reason) {
          _infoStrings.add("remote user $uid left channel");
          callMethods.endCall(call: widget.call); //added by me
          setState(() {
            _remoteUid = null;
          });
        },
        error: (code) {
          if (code.toString() == "ErrorCode.TokenExpired") {
            AlertUtils.toast('Session time out.');
            callMethods.endCall(call: widget.call);
          }
          setState(() {
            final info = 'onError: $code';
            _infoStrings.add(info);
          });
        },
      ),
    );
  }

  /// Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return Container();
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine?.muteLocalAudioStream(muted);
  }

  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic : Icons.mic_off,
              color: muted ? Colors.white : KColors.PRIMARY,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? KColors.PRIMARY : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () {
              callMethods.endCall(call: widget.call);
            },
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: KColors.RED,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _switchCamera,
            child: Icon(
              Icons.switch_camera,
              color: KColors.PRIMARY,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  _bgImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Stack(
        children: [
          Positioned(
            top: 24,
            left: 48,
            right: 48,
            bottom: 24,
            child: Image.asset(
              'images/logo.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(.85),
          )
        ],
      ),
    );
  }

  _switchCamera() {
    _engine?.switchCamera().then((value) {
      print('Camera switched!');
    }).catchError((err) {
      print('switchCamera $err');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      body: Center(
        child: Stack(
          children: <Widget>[
            _renderRemoteVideo(),
            _renderLocalPreview(),
            _panel(),
            _toolbar(),
          ],
        ),
      ),
    );
  }

  // current user video
  Widget _renderLocalPreview() {
    return Positioned(
      top: 8,
      left: 8,
      child: Container(
        width: 80,
        height: 100,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: widget.call.useVideo! ? RtcLocalView.SurfaceView() : Container(),
        ),
      ),
    );
  }

  // remote user video
  Widget _renderRemoteVideo() {
    if (_remoteUid != null && widget.call.useVideo!) {
      return RtcRemoteView.SurfaceView(uid: _remoteUid!);
    } else {
      return _bgImage();
    }
  }
}
