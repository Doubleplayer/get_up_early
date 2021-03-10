import 'dart:async';
import 'dart:convert';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:rxdart/subjects.dart';
import 'package:http/http.dart' as http;
import 'package:animated_card/animated_card.dart';
import '../../data/data.dart' as server;
class MusicPlayerPage extends StatefulWidget {
  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  Duration current_duration;
  bool isplaying = false;
  int playIndex = 0;
  StreamSubscription<Playing> listen_evevt;
  StreamSubscription<PlayingAudio> ready_event;
  bool now = false;
  String playurl;
  int playid = 0;
  int showid = 0;
  List<bool> refreshsign;
  String XiaoXiao = '2283923333';
  //final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();
  final _assetsAudioPlayer = AssetsAudioPlayer();
  final List<StreamSubscription> _subscriptions = [];
  List<List<Map>> playList = [];
  List<List<Audio>> songlist = [];

  @override
  void initState() {
    super.initState();
    refreshsign = [true, true];
    playList.add(List<Map>());
    playList.add(List<Map>());
    songlist.add(List<Audio>());
    songlist.add(List<Audio>());
    initplaylist(0).then((val) {
      setState(() {
        refreshsign[0] = false;
      });
    });
    initplaylist(1, playlistid: XiaoXiao).then((val) {
      setState(() {
        refreshsign[1] = false;
        print(
            "1111111222222222222222222255555555555555555555554444444444444444");
      });
    });
  }

  Future initplaylist(int index, {String playlistid = '5326989574'}) async {
    try {
      //更新标志，正在更新就不执行
      //上锁
      playList[index].clear();
      songlist[index].clear();
      var result = await http
          .get("http://${server.host}:3000/playlist/detail?id=${playlistid}");

      var templist = jsonDecode(result.body)['playlist']["trackIds"];
      initAudio();
      // if (_assetsAudioPlayer.current.value != null) {
      //   _assetsAudioPlayer.stop();
      //   _assetsAudioPlayer.current.value.playlist.audios.clear();
      // }
      int count = 0;
      for (var item in templist) {
        print(item);

        var value = await http
            .get("http://${server.host}:3000/song/detail?ids=${item['id']}");
        print("......................");
        // print(jsonDecode(value.body));

        var info = jsonDecode(value.body)['songs'][0];
        var song = {};
        print(info);
        song['name'] = info['name'];
        song['id'] = info['id'];
        song['artist'] = info['ar'][0]['name'];
        song['album'] = info['al']['name'];
        song['artwork'] = info['al']['picUrl'];
        var url_val =
            await http.get("http://${server.host}:3000/song/url?id=${song['id']}");
        song['url'] = jsonDecode(url_val.body)['data'][0]['url'];
        if (song['url'] == null) {
          continue;
        }
        playList[index].add(song);
        var audio = Audio.network(song['url'],
            metas: Metas(
              title: song['name'],
              artist: song['artist'],
              album: song['album'],
              image: MetasImage.network(song['artwork']),
            ));
        songlist[index].add(audio);
        count++;
        if (count == 1 && playid == index) {
          playIndex = 0;
          isplaying = false;
          _assetsAudioPlayer.open(songlist[playid][playIndex],
              showNotification: false, autoStart: false);
        }
        setState(() {});
      }
    } catch (e) {
      refreshsign[index] = false;
      setState(() {});
    }

    // initAudio();
  }

  void initAudio() async {
    // for (var song in playList) {
    //   songlist.add(audio);
    // }
    if (listen_evevt != null) listen_evevt.cancel();
    listen_evevt =
        _assetsAudioPlayer.playlistAudioFinished.listen((event) async {
      playIndex = (playIndex + 1) % songlist[playid].length;
      _assetsAudioPlayer.open(songlist[playid][playIndex],
          showNotification: false, autoStart: true);
      setState(() {
        print("...............");
        print(playIndex);
        print("...............");
      });
    });

    if (ready_event != null) ready_event.cancel();
    ready_event = _assetsAudioPlayer.onReadyToPlay.listen((event) {
      setState(() {});
    });
    print(playIndex);
  }

  @override
  void dispose() {
    if (listen_evevt != null) listen_evevt.cancel();
    if (ready_event != null) ready_event.cancel();
    _assetsAudioPlayer.pause();
    super.dispose();
    _assetsAudioPlayer.dispose();
    print("dispose");
  }

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: [
            InkWell(
              child: Icon(Icons.refresh),
              onTap: () async {
                if (refreshsign[showid] == false) {
                  refreshsign[showid] = true;
                  if (showid == 0) {
                    initplaylist(showid)
                        .then((value) => refreshsign[showid] = false);
                  } else {
                    initplaylist(showid, playlistid: XiaoXiao)
                        .then((value) => refreshsign[showid] = false);
                  }
                }
              },
            )
          ],
          backgroundColor: Theme.of(context).primaryColor,
          title: InkWell(
            child: now
                ? Text("北甍北甍的歌单~", style: TextStyle(fontFamily: "MyOwnFonts"))
                : Text("汉儿最近觉得很好听的歌~",
                    style: TextStyle(fontFamily: "MyOwnFonts")),
            onTap: () {
              setState(() {
                now = !now;
                if (now) {
                  showid = 1;
                } else {
                  showid = 0;
                }
              });
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: playList[playid].length != 0
            ? Opacity(
                opacity: 0.92,
                child: Container(
                  height: 90,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(
                        image: NetworkImage(
                            playList[playid][playIndex]['artwork']),
                        fit: BoxFit.cover),
                  ),
                  child: ListTile(
                    leading: ClipOval(
                      child: Image.network(
                        playList[playid][playIndex]['artwork'],
                        fit: BoxFit.cover,
                        height: 60,
                        width: 60,
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          playList[playid][playIndex]['name'],
                          style: TextStyle(fontFamily: "MyOwnFonts"),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                        ),
                        _assetsAudioPlayer.current.value != null
                            ? PlayerBuilder.currentPosition(
                                player: _assetsAudioPlayer,
                                builder: (context, duration) {
                                  // Text(duration.toString() + '/' + _assetsAudioPlayer.current.value.audio.duration.toString())
                                  return Expanded(
                                    child: Slider(
                                      inactiveColor: Colors.white70,
                                      activeColor: Colors.pinkAccent,
                                      max: 1.0,
                                      min: 0,
                                      onChanged: (value) {
                                        _assetsAudioPlayer.seek(
                                            _assetsAudioPlayer.current.value
                                                    .audio.duration *
                                                value);
                                      },
                                      value: duration.inSeconds /
                                          _assetsAudioPlayer.current.value.audio
                                              .duration.inSeconds,
                                    ),
                                  );
                                })
                            : SizedBox(),
                      ],
                    ),
                    trailing: NeumorphicButton(
                      style: NeumorphicStyle(
                        color: Colors.white60,
                        boxShape: NeumorphicBoxShape.circle(),
                      ),
                      onPressed: () async {
                        setState(() {
                          isplaying = !isplaying;
                        });
                        _assetsAudioPlayer.playOrPause();
                      },
                      child: Icon(
                        isplaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ),
              )
            : SizedBox(),
        backgroundColor: Theme.of(context).primaryColor,
        body: ListView.builder(
          itemCount: playList[showid].length,
          itemBuilder: (context, index) {
            return AnimatedCard(
              direction:
                  AnimatedCardDirection.right, //Initial animation direction
              initDelay: Duration(milliseconds: 0), //Delay to initial animation
              duration: Duration(
                  seconds: 1, milliseconds: 100), //Initial animation duration
              // onRemove: () =>
              //     lista.removeAt(index), //Implement this action to active dismiss
              curve: Curves.bounceOut, //Animation curve
              child: Container(
                height: 80,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(50)),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(25)),
                  color: Colors.white,
                  elevation: 0,
                  child: ListTile(
                    trailing: (showid == playid && index == playIndex)
                        ? (isplaying
                            ? Text(
                                '播放中',
                                style: TextStyle(color: Colors.green),
                              )
                            : Text(
                                "暂停",
                                style: TextStyle(color: Colors.redAccent),
                              ))
                        : null,
                    title: Text(
                      playList[showid][index]["name"],
                      style: TextStyle(fontFamily: "MyOwnFonts"),
                    ),
                    subtitle: Text(playList[showid][index]["artist"].toString(),
                        style: TextStyle(fontFamily: "MyOwnFonts")),
                    // leading: Container(
                    //   height: 50,
                    //   width: 50,
                    //   child: Hero(
                    //       tag: index,
                    //       child: Image.network(playList[index]["artwork"],
                    //           fit: BoxFit.cover)),
                    // ),
                    onTap: () {
                      setState(() {
                        _assetsAudioPlayer.open(songlist[showid][index],
                            showNotification: false, autoStart: true);
                        isplaying = true;
                        playIndex = index;
                        playid = showid;
                        print("...................");
                        print(playList[showid][index]);
                        print(_assetsAudioPlayer
                            .current.value.playlist.audios.length);
                        print(playList[showid][index]);
                        print("...................");
                      });
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
