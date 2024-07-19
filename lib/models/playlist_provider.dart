import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/models/songs.dart';
class PlaylistProvider extends ChangeNotifier{
  //playlist of songs
  final List<Song> _playlist =[
    //song 1
    Song(
        songName: "Kya Kardiya",
        artistName: "Sushant KC",
        albumArtImagePath: "assets/images/Kya_Kardiya.jpg",
        audioPath: "audio/Kya_Kardiya.mp3"
    ),
    //song 2
    Song(
        songName: "Tauba Tauba",
        artistName: "Karan Aujla",
        albumArtImagePath: "assets/images/Tauba_Tauba.jpg",
        audioPath: "audio/Tauba_Tauba.mp3"
    ),
    //song 3
    Song(
        songName: "Soni Soni",
        artistName: "Darshan Raval",
        albumArtImagePath: "assets/images/Soni_Soni.jpg",
        audioPath: "audio/Soni_Soni.mp3"
    ),
  ];
  //current song playing
  int? _currentSongIndex;
  /*

  A U D I O P L A Y E R

  */
  //audio player
  final AudioPlayer _audioPlayer=AudioPlayer();

  //duration
  Duration _currentDuration= Duration.zero;
  Duration _totalDuration = Duration.zero;

  //constructor
  PlaylistProvider(){
    listenToDuration();
  }
  //initially not playing
  bool _isPlaying=false;
  //play the song
  void play() async{
    final String path=_playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop();//stop current song
    await _audioPlayer.play(AssetSource(path));//play the new song
    _isPlaying=true;
    notifyListeners();
  }
  //pause the song
  void pause() async{
    await _audioPlayer.pause();
    _isPlaying=false;
    notifyListeners();
  }
  //resume playing
  void resume() async{
    await _audioPlayer.resume();
    _isPlaying=true;
    notifyListeners();
  }
  //pause or resume
  void pauseOrResume() async{
    if(_isPlaying){
      pause();
    }
    else{
      resume();
    }
    notifyListeners();
  }
  //seek to a position in current song
  void seek(Duration position) async{
    await _audioPlayer.seek(position);
    notifyListeners();
  }
  //play next song
  void playNextSong(){
    if(_currentSongIndex!=null){
      if(_currentSongIndex!<_playlist.length-1){
        //go to the next song if it is not the last song
        currentSongIndex=_currentSongIndex!+1;
      }
      else{
        //if it is the last song, loop back to the first song
        currentSongIndex=0;
      }
    }
  }
  //play previous song
  void playPreviousSong() async{
    //if more than 2 seconds have passed, restart the currentsong
    if(_currentDuration.inSeconds>2){
      _audioPlayer.seek(Duration.zero);
    }
    else{
      if(_currentSongIndex!>0) {
        currentSongIndex = _currentSongIndex! - 1;
      }
        else{
          //if it is the last song, loop back to the first song
          currentSongIndex= playlist.length-1;
        }
      }
    }
  // listen to duration
  void listenToDuration(){
    //listen for total duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration =newDuration;
      notifyListeners();
    });
    //listen for current duration
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration =newPosition;
      notifyListeners();
    });
    //listen for song completion
    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }
  // dispose audio player


  /*

  G E T T E R S

  */

  List<Song> get playlist =>_playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying=>_isPlaying;
  Duration get currentDuration=>_currentDuration;
  Duration get totalDuration=>_totalDuration;

  /*

  S E T T E R S

  */
  set currentSongIndex(int? newIndex){
    _currentSongIndex=newIndex;
    if(newIndex!=null){
      play();//play the song at the new index
    }
    notifyListeners();
  }
}