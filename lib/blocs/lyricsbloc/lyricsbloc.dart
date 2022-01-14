import 'package:dalvic_lyrics_sharing_app/blocs/lyricsbloc/lyricsb.dart';
import 'package:dalvic_lyrics_sharing_app/models/Lyrics.dart';
import 'package:dalvic_lyrics_sharing_app/repository/lyricsRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'lyricsEvent.dart';

class LyricsBloc extends Bloc<LyricsEvents, LyricsState> {
  LyricsRepository lyricsRepository;
  LyricsBloc({@required this.lyricsRepository})
      : assert(lyricsRepository != null),
        super(LyricsIdleState());

  @override
  Stream<LyricsState> mapEventToState(LyricsEvents event) async* {
    // TODO: implement mapEventToState
    try {
      if (event is CreateLyricsEvent) {
        yield LyricsBusyState();
        await lyricsRepository.CreateLyrics(event.lyrics);
        yield LyricsCreateSuccessState();
      } else if (event is GetAllLyrics) {
        List<Lyrics> lyrics = await lyricsRepository.GetLyrics();
        print(lyrics);
        yield LyricsSuccesState(lyrics);
      }
      else if(event is DeleteMyLyrics){
        try{
          await lyricsRepository.deleteLyrics(lyricsId: event.lyricsId);
          yield DeleteMyLyricsSuccesState();
        }catch(error){
          print(error);
          yield DeleteMyLyricsFailedState();
        }
      }
      else if(event is UpdateMyLyrics) {
        try {
          yield UpdateMyLyricsBusyState();
          Lyrics lyrics = await lyricsRepository.updateMyLyrics(
              lyrics: event.lyrics);
          yield UpdateMyLyricsSuccessState(lyrics: lyrics);
        } catch (error) {
          print(error);
          yield UpdateMyLyricsFailedState();
        }
      }
      else if(event is GetMyLyrics){
        try{
          yield GetMyLyricsBusyState();
          var lyricss = await lyricsRepository.getMyLyrics();
          yield GetMyLyricsSuccessState(lyricss: lyricss);
        }catch(error){
          print(error);
          yield GetMyLyricsFailedState();
        }
      }
    } catch (error, stacktrace) {
      print(error);
      print(stacktrace);
      yield LyricsFailedState(errorMessage: 'Lyrics Creation Failed!');
    }
  }
}
