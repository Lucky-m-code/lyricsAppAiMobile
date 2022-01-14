import 'dart:convert';
import 'dart:io';

import 'package:dalvic_lyrics_sharing_app/data_provider/BaseDataProvider.dart';
import 'package:dalvic_lyrics_sharing_app/helper/localhelper.dart';
import 'package:dalvic_lyrics_sharing_app/models/Lyrics.dart';
import 'package:dalvic_lyrics_sharing_app/models/hompagestat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LyricsDataProvider extends BaseDataProvider{
  final http.Client httpClient;
  final LocalHelper localHelper;

  LyricsDataProvider({@required this.httpClient, @required this.localHelper}):assert(httpClient!=null);
  Future<List<Lyrics>> getMyLyrics() async {
    //the await keyword to get the completed result of an asynchronous expression. The await keyword only works within an async function.
    var response = await httpClient.get('$baseUrl/userlyrics/${localHelper.getUser().id}', headers: {HttpHeaders.authorizationHeader: "Bearer ${localHelper.getUser().token}"});
    List<Lyrics> lyrics = new List<Lyrics>();

    //Manual JSON decoding refers to using the built-in JSON decoder in dart:convert.
    //It involves passing the raw JSON string to the jsonDecode() function, and then looking up the values you need in the resulting Map<String, dynamic>.
    List<dynamic> rawData = jsonDecode(response.body)["data"];
    rawData.forEach((element) {
      lyrics.add(Lyrics.fromJson(element));
    });
    // for(int i = 0; i < rawData.length; i++){
    //   lyrics.add(Lyricslyrics.fromJson(rawData[i]));
    // }
    print(lyrics);
    return lyrics;
  }
  Future<List<Lyrics>> getRecom() async {
    //the await keyword to get the completed result of an asynchronous expression. The await keyword only works within an async function.
    var response = await httpClient.get('$baseUrl/lyricsRecom', headers: {HttpHeaders.authorizationHeader: "Bearer ${localHelper.getUser().token}"});
    List<Lyrics> lyrics = new List<Lyrics>();
    print('here');
    //Manual JSON decoding refers to using the built-in JSON decoder in dart:convert.
    //It involves passing the raw JSON string to the jsonDecode() function, and then looking up the values you need in the resulting Map<String, dynamic>.
    List<dynamic> rawData = jsonDecode(response.body);
    print(rawData[1]);
    rawData[1].forEach((element) {
      lyrics.add(Lyrics.fromJson(element));
    });
    // for(int i = 0; i < rawData.length; i++){
    //   lyrics.add(Lyricslyrics.fromJson(rawData[i]));
    // }
    print(lyrics);
    return lyrics;
  }

  Future<Lyrics> updateMyLyrics({Lyrics lyrics}) async {
    var response = await httpClient.post('$baseUrl/lyrics/${lyrics.id}', body: {
      "music_name": lyrics.musicName,
      "artist_name": lyrics.artistName,
      "lyrics":lyrics.lyrics,
      "url": lyrics.url,
      "_method": "PUT",
    },headers: {HttpHeaders.authorizationHeader: "Bearer ${localHelper.getUser().token}"});
    print(response.body);
    Lyrics lyric = Lyrics.fromJson(jsonDecode(response.body)["data"]);
    return lyric;
  }

  Future<Lyrics> CreateLyrics(Lyrics lyrics) async{
    print("name: ${lyrics.artistName}");
    print("name: ${lyrics.musicName}");
    print("name: ${lyrics.url}");
    print("name: ${lyrics.lyrics}");
    var user = localHelper.getUser();
    final response = await httpClient.post(
          "$baseUrl/lyrics",
          body: {
            'music_name': lyrics.musicName,
            'artist_name': lyrics.artistName,
            'lyrics': lyrics.lyrics,
            'url': lyrics.url,
          },
            headers: {HttpHeaders.authorizationHeader: "Bearer ${user.token}"}, );
    // var response = await http.post(
    //     "$baseUrl/lyrics",
    //   body: {
    //       "music_name":"test",
    //     "artist_name":"test",
    //     "lyrics":"test",
    //     "url":"test",
    //   },
    //   headers: {HttpHeaders.authorizationHeader: "Bearer 7|Aapx3SyX9PnKyNakMp4581imSeqDpI7T9R5xH3lF"}
    // );
          print("response: ${response.body}");
        if(response.statusCode==200){
          return Lyrics.fromJson(jsonDecode(response.body)["response"]["lyrics"]);
        }
        else{
          throw Exception('failed to created Lyrics');
        }
  }
  Future<List<Lyrics>> getLyrics() async {
    final response = await httpClient.get('$baseUrl/lyrics', headers: {HttpHeaders.authorizationHeader: "Bearer 7|Aapx3SyX9PnKyNakMp4581imSeqDpI7T9R5xH3lF"});

    if (response.statusCode == 200) {
      List<dynamic> lyrics = jsonDecode(response.body)["data"];
      return lyrics.map((lyrics) => Lyrics.fromJson(lyrics)).toList();
    } else {
      throw Exception('Failed to load lyrics');
    }
  }

  Future<List<Lyrics>> getAllLyrics({page=1}) async {
    final response = await httpClient.get('$baseUrl/public/lyrics?page=$page');

    if (response.statusCode == 200) {
      List<dynamic> lyrics = jsonDecode(response.body)["data"];
      print(lyrics);
      return lyrics.map((lyrics) => Lyrics.fromJson(lyrics)).toList();
    } else {
      throw Exception('Failed to load lyrics');
    }
  }

  Future<void> deleteLyrics({int lyricsId}) async {
    var response = await httpClient.delete('$baseUrl/lyrics/$lyricsId', headers: {HttpHeaders.authorizationHeader: "Bearer ${localHelper.getUser().token}"});
    if(response.statusCode == 200){
      return null;
    }else{
      throw Exception("Failed deleting lyrics lyrics");
    }
  }

  Future<HomepageStat> getHomepageStat() async {
    var response = await httpClient.get('$baseUrl/admin/totalstatus', headers: {HttpHeaders.authorizationHeader: "Bearer ${localHelper.getUser().token}"});
    print(response.body);
    if(response.statusCode == 200){
      HomepageStat stat = HomepageStat.fromJson(jsonDecode(response.body));
      return stat;
    }else{
      throw Exception("Failed to fetch homepage stat");
    }
  }
}
