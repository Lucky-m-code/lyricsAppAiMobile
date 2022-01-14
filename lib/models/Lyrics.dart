import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Lyrics extends Equatable{
  final int id;
  final String musicName;
  final String artistName;
  final String lyrics;
  final bool status;
  final String url;
  Lyrics({@required this.musicName,@required this.artistName,@required this.lyrics,this.url,this.id,this.status});


  factory Lyrics.fromJson(Map<String, dynamic> json){
    return Lyrics(
      id: json['id'],
      musicName: json['music_name'],
      artistName: json['artist_name'],
      lyrics: json['lyrics'],
      status: true,
      url: json['url'],
    );
  }
  @override
  // TODO: implement props
  List<Object> get props => [id,musicName,artistName,lyrics,status,url  ];
}



// $table->id();
// $table->timestamps();
// $table->string('music_name');
// $table->string('artist_name');
// $table->text('lyrics');
// $table->text('url');
// $table->boolean('status');