import 'package:dalvic_lyrics_sharing_app/blocs/authenticationbloc/authenticationbloc.dart';
import 'package:dalvic_lyrics_sharing_app/blocs/authenticationbloc/authenticationevent.dart';
import 'package:dalvic_lyrics_sharing_app/blocs/homepagebloc/homepagebloc.dart';
import 'package:dalvic_lyrics_sharing_app/blocs/signinbloc/signinbloc.dart';
import 'package:dalvic_lyrics_sharing_app/blocs/signinbloc/signinevent.dart';
import 'package:dalvic_lyrics_sharing_app/blocs/signinbloc/signinstate.dart';
import 'package:dalvic_lyrics_sharing_app/constants.dart';
import 'package:dalvic_lyrics_sharing_app/models/user.dart';
import 'package:dalvic_lyrics_sharing_app/screens/homepage.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginPage extends StatefulWidget {
  static const String pathName = '/login';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _showPassword = false;
  var _password, _email = "";
  GlobalKey _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: kPrimary, //or set color with: Color(0xFF0000FF)
    // ));
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: [
            Container(
              color: kPrimary,
              height: 300.0,
              width: double.infinity,
            ),
            Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Image(
                        image: AssetImage("assets/images/logo.png"),
                        width: 100,
                      ),
                      Card(
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 25.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      color: kPrimary,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      _formField('Email', (value) {
                                          if(!EmailValidator.validate(value)){
                                            return "Invalid email address";
                                          }
                                          return null;
                                      },false, _email),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: TextFormField(
                                          initialValue: _password,
                                          onChanged: (newVal) {
                                            setState(() {
                                              _password = newVal;
                                            });
                                          },
                                          obscureText: !_showPassword,
                                          decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _showPassword =
                                                      !_showPassword;
                                                });
                                              },
                                              icon: Icon(_showPassword
                                                  ? Icons.visibility
                                                  : Icons.visibility_off),
                                            ),
                                            labelText: 'Password',
                                            hintStyle: TextStyle(color: kHint),
                                            fillColor: kPrimaryLight,
                                            filled: true,
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white,
                                                    width: 1.0)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: kPrimary,
                                                    width: 1.0)),
                                          ),
                                        ),
                                      )
                                    ],
                                  )),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: BlocConsumer<SignInBloc,SignInState>(
                                  listener: (context ,state){

                                    if(state is SignInFailedState){
                                      _scaffoldKey.currentState.showSnackBar(SnackBar(content : Text('${state.errorMessage}')));
                                    }
                                    else if(state is SignInSuccesState){
                                      _scaffoldKey.currentState.showSnackBar(SnackBar(content : Text('logged in succesfully!')));
                                      BlocProvider.of<AuthenticationBloc>(context)..add(SaveAuthenticationInfo(user: state.user))..add(InitEvent());
                                      if(state.user.isAdmin == null){
                                        BlocProvider.of<HomePageBloc>(context)..add(HomepageEvent.GetLyrics)..add(HomepageEvent.GetTotalStatus);
                                      }else{
                                        BlocProvider.of<HomePageBloc>(context)..add(HomepageEvent.GetLyrics);
                                      }
                                      Navigator.of(context).pushNamedAndRemoveUntil(HomePage.pathName, (route) => false);
                                    }
                                  },
                                  builder: (context ,state){
                                    if(state is SignInBusyState){
                                      return SpinKitWave(color: kPrimary,size: 25,);
                                    }
                                     return FlatButton(
                                          minWidth: double.infinity,
                                          height: 50,
                                          onPressed: ()  {
                                            User user = User();
                                            user.email = _email;
                                            user.password = _password;
                                            print('${_email} ${_password}');
                                            BlocProvider.of<SignInBloc>(context)..add(SignIn(user: user));
                                          },
                                          color: kPrimary,
                                          child: Text(
                                            'Login',
                                            style: TextStyle(color: Colors.white),
                                          ));
                                    })),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('Don\'t have account '),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pushReplacementNamed('/signup');
                                            },
                                            child: Text(
                                              'Sign up',
                                              style: TextStyle(color: kPrimary),
                                            ))
                                      ],
                                    ),
                                      ])))]))))
    ])));}

  Widget _formField(hint, validator, [password = false, value]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: value,
        onChanged: (newVal) {
          setState(() {
            _email = newVal;
          });
        },
        validator: (value)=>validator(value),
        obscureText: password ? _showPassword : false,
        decoration: InputDecoration(
          suffixIcon: password
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                  icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off),
                )
              : null,
          labelText: '$hint',
          hintStyle: TextStyle(color: kHint),
          fillColor: kPrimaryLight,
          filled: true,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1.0)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kPrimary, width: 1.0)),
        ),
      ),
    );
  }
}
