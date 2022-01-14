import 'package:dalvic_lyrics_sharing_app/blocs/authenticationbloc/authenticationbloc.dart';
import 'package:dalvic_lyrics_sharing_app/blocs/authenticationbloc/authenticationevent.dart';
import 'package:dalvic_lyrics_sharing_app/blocs/authenticationbloc/authenticationstate.dart';
import 'package:dalvic_lyrics_sharing_app/blocs/homepagebloc/homepagebloc.dart';
import 'package:dalvic_lyrics_sharing_app/blocs/homepagebloc/homepagestate.dart';
import 'package:dalvic_lyrics_sharing_app/helper/constants.dart';
import 'package:dalvic_lyrics_sharing_app/widgets/lyricslistitem.dart';
import 'package:flutter/material.dart';
import 'package:dalvic_lyrics_sharing_app/models/Lyrics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LyricsPage extends StatelessWidget {
  static const routeName = 'lyricsPage';

  final Lyrics lyrics;
  LyricsPage({@required this.lyrics}) : assert(lyrics != null);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          child: Container(
            child: Column(
              children: [
                Text(
                  '${lyrics.musicName}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                ),
                Text(
                  '${lyrics.artistName}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ),
        // actions: [IconButton(icon: Icon(Icons.favorite_border,color: Colors.white,), onPressed: null, padding: EdgeInsets.zero,)],
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
          child: SingleChildScrollView(
              child: Center(
                  child: Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      child: Column(children: [
                        Text(
                          '${lyrics.lyrics}',
                          style: TextStyle(wordSpacing: 10),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            'Recomended',
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        BlocBuilder<HomePageBloc, HomepageState>(
                          buildWhen: (prevstate, currentstate) {
                            if (currentstate is HomepageStatBusyState ||
                                currentstate is HomepageStatSuccessState ||
                                currentstate is HomepageStatFailedState) {
                              return false;
                            }
                            return true;
                          },
                          builder: (context, state) {
                            if (state is HomepageSuccessState) {
                              BlocProvider.of<HomePageBloc>(context)
                                  .add(HomepageEvent.GetTotalStatus);
                              return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: state.lyrics.length,
                                  itemBuilder: (context, index) =>
                                      LyricsListItem(
                                        lyrics: state.lyrics[index],
                                      ));
                            } else if (state is HomepageBusyState) {
                              return SpinKitWave(
                                color: kPrimary,
                                size: 25,
                              );
                            } else {
                              return Center(
                                child: GestureDetector(
                                    onTap: () {
                                      BlocProvider.of<HomePageBloc>(context)
                                          .add(HomepageEvent.GetRecom);
                                    },
                                    child: Text("Failed click to retry")),
                              );
                            }
                          },
                        ) // width: MediaQuery.of(context).size.width * 0.8,
                      ]))))),
    );
  }
}
