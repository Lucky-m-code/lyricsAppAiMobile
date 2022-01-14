import 'package:dalvic_lyrics_sharing_app/blocs/authenticationbloc/authenticationbloc.dart';
import 'package:dalvic_lyrics_sharing_app/blocs/authenticationbloc/authenticationevent.dart';
import 'package:dalvic_lyrics_sharing_app/blocs/authenticationbloc/authenticationstate.dart';
import 'package:dalvic_lyrics_sharing_app/blocs/homepagebloc/homepagebloc.dart';
import 'package:dalvic_lyrics_sharing_app/blocs/homepagebloc/homepagestate.dart';
import 'package:dalvic_lyrics_sharing_app/blocs/lyricsbloc/lyricsb.dart';
import 'package:dalvic_lyrics_sharing_app/helper/constants.dart';
import 'package:dalvic_lyrics_sharing_app/screens/addlyricspage.dart';
import 'package:dalvic_lyrics_sharing_app/widgets/dashboardcard.dart';
import 'package:dalvic_lyrics_sharing_app/widgets/lyricslistitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  static const String pathName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime currentBackPressTime;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: (){
          DateTime now = DateTime.now();
          if (currentBackPressTime == null ||
              now.difference(currentBackPressTime) > Duration(seconds: 2)) {
            currentBackPressTime = now;
            Fluttertoast.showToast(msg: "press back again to exit");
            return Future.value(false);
          }
          return Future.value(true);
        },
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Container(
                          //   child: Text(
                          //     'Find Lyrics',
                          //     style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                          //   ),
                          // ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.symmetric(vertical: 24),
                              height: 60,
                              decoration: BoxDecoration(
                                  color: kPrimaryLight,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Search',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Icon(
                                    Icons.search,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            ),
                          ),
                            BlocBuilder<AuthenticationBloc, AuthenticationState>(
                            builder: (context, state) {
                              if (state is Authenticated)
                                return Row(
                                    children: [
                                      SizedBox(
                                        width: 30.0,
                                        child: IconButton(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, '/profile');
                                            },
                                            icon: Icon(
                                              Icons.person,
                                              color: Colors.grey,
                                            )),
                                      ),
                                      SizedBox(
                                        width: 30.0,
                                        child: IconButton(
                                            onPressed: () async {
                                              // Navigator.pushNamed(context, '/l');
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text('Logout',
                                                        style: TextStyle(
                                                            color: kPrimary),),
                                                      content: Text(
                                                          'Are you sure?'
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                  context)
                                                                  .pop();
                                                            },
                                                            child: Text('No')),
                                                        TextButton(
                                                            onPressed: () {
                                                              BlocProvider.of<
                                                                  AuthenticationBloc>(
                                                                  context).add(
                                                                  Logout());
                                                              Navigator
                                                                  .pushNamedAndRemoveUntil(
                                                                  context,
                                                                  '/', (
                                                                  route) => false);
                                                            },
                                                            child: Text('Yes'))
                                                      ],
                                                    );
                                                  }
                                              );
                                            },
                                            icon: Icon(
                                              Icons.exit_to_app_rounded,
                                              color: Colors.grey,
                                            )),
                                      ),
                                    ]
                                );
                              return SizedBox();
                            }
                          )
                        ],
                      ),
                      BlocBuilder<AuthenticationBloc, AuthenticationState>(

                        builder: (context, state){
                          if(state is Authenticated){
                            print("user user: ${state.user.toString()}");
                            if(state.user.isAdmin==null){
                              return BlocConsumer<HomePageBloc, HomepageState>(
                                  listener: (context,  state){
                                    print('current state: ${state}');
                                    if(state is HomepageStatSuccessState){
                                      // BlocProvider.of<HomePageBloc>(context).add(HomepageEvent.GetLyrics);
                                    }
                                  },
                                  buildWhen: (prevstate, currentstate){
                                    if(currentstate is HomepageStatBusyState || currentstate is HomepageStatSuccessState || currentstate is HomepageStatFailedState){
                                      return true;
                                    }
                                    return false;
                                  },
                              builder: (context, state){
                                if(state is HomepageStatSuccessState){
                                  // BlocProvider.of<HomePageBloc>(context).add(HomepageEvent.GetLyrics);
                                  print("state $state");
                                  return Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(bottom: 10.0),
                                        child: Row(
                                          children: [
                                            DashboardCard(icon: Icons.person, title: '${state.stat.totalUser}', content: 'Users', colors: [Color(0xFF4ECDC4), Color(0xFF556270)],),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            DashboardCard(icon: Icons.text_snippet_outlined, title: '${state.stat.totalLyrics}', content: 'Lyrics\'s', colors: [Color(0xFF42275a), Color(0xFF734b6d)],),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(bottom: 10.0),
                                        child: Row(
                                          children: [
                                            DashboardCard(icon: Icons.adjust, title: '${state.stat.totalLyricsRequest}', content: 'Request', colors: [Color(0xFFFF5F6D), Color(0xFFFFC371)],),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            DashboardCard(icon: Icons.report_gmailerrorred_outlined, title: '${state.stat.totalUnApprovedLyrics}', content: 'Unapproved', colors: [Color(0xFF3a7bd5), Color(0xFF3a6073)],),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                else if(state is HomepageStatBusyState){
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SpinKitWave(
                                      size: 25,
                                      color: kPrimary,
                                    ),
                                  );
                                }else {
                                  return GestureDetector(onTap: (){BlocProvider.of<HomePageBloc>(context)..add(HomepageEvent.GetTotalStatus);},child: Text('Failed to fetch stat, tap to retry'));
                                }
                              });
                            }
                          }
                          return Container();
                        }
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        height: 120.0,
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 10.0),
                        child: Stack(
                          children: [
                            Container(
                                width: double.infinity,
                                child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    child: Image.asset(
                                      'assets/images/banner.jpg',
                                      fit: BoxFit.cover,
                                    ))),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 120.0,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [kPrimary, Colors.black.withOpacity(0.0)]
                                  )
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Dalvic Lyrics Sharing', style:TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold)),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'Lyrics',
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      BlocBuilder<HomePageBloc, HomepageState>(
                        buildWhen: (prevstate, currentstate){
                          if(currentstate is HomepageStatBusyState || currentstate is HomepageStatSuccessState || currentstate is HomepageStatFailedState){
                            return false;
                          }return true;
                        },
                        builder: (context, state) {
                          if (state is HomepageSuccessState) {
                            BlocProvider.of<HomePageBloc>(context).add(HomepageEvent.GetTotalStatus);
                            return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: state.lyrics.length,
                                itemBuilder: (context, index) => LyricsListItem(
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
                                        .add(HomepageEvent.GetLyrics);
                                  },
                                  child: Text("Failed click to retry")),
                            );
                          }
                        },
                      )
                    ]),
              ),
            )),
      ),
      floatingActionButton: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) => FloatingActionButton(
          onPressed: () {
            if(state is Authenticated)
            Navigator.pushNamed(context, AddLyricsPage.routeName);
            else
              _scaffoldKey.currentState.showSnackBar(
                SnackBar(content: Text('Login to add lyrics'), action: SnackBarAction(label: 'Login', onPressed: (){
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false,);
                },),)
              );
          },
          child: Icon(Icons.add),
          backgroundColor: kPrimary,
        ),
      ),
    );
  }
}
