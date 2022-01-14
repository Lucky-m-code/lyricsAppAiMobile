import 'package:dalvic_lyrics_sharing_app/data_provider/data_provider.dart';
import 'package:dalvic_lyrics_sharing_app/models/Lyrics.dart';
import 'package:dalvic_lyrics_sharing_app/models/hompagestat.dart';
import 'package:flutter/foundation.dart';

class HomepageRepository{
  final LyricsDataProvider lyricsDataProvider;
  HomepageRepository({@required this.lyricsDataProvider}):assert(lyricsDataProvider!=null);

  Future<List<Lyrics>> getAllLyrics({page=1}) async{
    return await lyricsDataProvider.getAllLyrics(page: page);
  }
  Future<List<Lyrics>> getRecomm({page=1}) async{
    return await lyricsDataProvider.getRecom();
  }

  Future<HomepageStat> getHomepageStat() async {
    return await lyricsDataProvider.getHomepageStat();
  }
}