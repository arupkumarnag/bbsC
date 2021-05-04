import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_client_reboot/blocs/auth_bloc.dart';
import 'package:grocery_client_reboot/styles/base.dart';
import 'package:grocery_client_reboot/widgets/alerts.dart';
import 'package:grocery_client_reboot/widgets/button.dart';
import 'package:grocery_client_reboot/widgets/social_button.dart';
import 'package:grocery_client_reboot/widgets/textfield.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
   @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  StreamSubscription _userSubscription;
  StreamSubscription _errorMessageSubscription;

  @override
  void initState() {
    final authBloc = Provider.of<AuthBloc>(context, listen: false);
    _userSubscription = authBloc.user.listen((user) {
      if (user != null) Navigator.pushReplacementNamed(context, '/landing');
    });

    ///Alert on incorrect Input
    _errorMessageSubscription = authBloc.errorMessage.listen((errorMessage) {
          if (errorMessage != '') {
            AppAlerts.showErrorDialog(context, errorMessage).then((_) => authBloc.clearErrorMessage());
          }
        });
    super.initState();
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    _errorMessageSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);

    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        child: pageBody(context, authBloc),
      );
    } else {
      return Scaffold(
        body: pageBody(context, authBloc),
      );
    }
  }


  Widget pageBody(BuildContext context, AuthBloc authBloc) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.indigo,
        body: ListView(
          // padding: EdgeInsets.all(0.0),
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * .2,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      // image: AssetImage('assets/images/top_bg.png'),
                      image: AssetImage('assets/images/rainbow-edit.png'),
                      fit: BoxFit.fill)),
            ),
            SizedBox(height: 50,),

            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * .3,     
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/bbs-ring-logo.png')),
                    ),
                  ),

                  StreamBuilder<String>(
                      stream: authBloc.email,
                      builder: (context, snapshot) {
                        return AppTextField(
                          hintText: 'Email',
                          materialIcon: Icons.email,
                          textInputType: TextInputType.emailAddress,
                          errorText: snapshot.error,
                          onChanged: authBloc.changeEmail,
                        );
                      }),
                  StreamBuilder<String>(
                      stream: authBloc.password,
                      builder: (context, snapshot) {
                        return AppTextField(
                          hintText: 'Password',
                          materialIcon: Icons.lock,
                          obscureText: true,
                          errorText: snapshot.error,
                          onChanged: authBloc.changePassword,
                        );
                      }),
                  StreamBuilder<bool>(
                      stream: authBloc.isValidLogin,
                      ///Added Seperate Logic
                      builder: (context, snapshot) {
                        return AppButton(
                          buttonText: 'Login',
                          buttonType: (snapshot.data == true)
                              ? ButtonType.LightBlue
                              : ButtonType.Disabled,
                          onPressed: () {
                            authBloc.loginEmail();

                            ///Flutter Toast
                            Fluttertoast.showToast(
                              msg: "Hold On, Logging you in...",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.blueAccent,
                              textColor: Colors.white,
                              fontSize: 20.0,
                            );
                          },
                        );
                      }),
                  SizedBox(
                    height: 25.0,
                  ),



                  //Google Signin
                  Center(
                    child: Text('Or', style: GoogleFonts.mcLaren(
                        fontSize: 20.0, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  Padding(
                    padding: BaseStyles.listPadding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // AppSocialButton(
                        //   socialType: SocialType.Facebook,
                        // ),
                        SizedBox(width: 15.0),
                        InkWell(
                          child: Center(
                            child: AppSocialButton(socialType: SocialType.Google),
                          ),
                          onTap: authBloc.signinGoogle,
                        ),
                      ],
                    ),
                  ),

                  ///====Signup Screen Nav
                  Padding(
                    padding: BaseStyles.listPadding,
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: 'New Here ? ',
                            // style: TextStyles.body,
                            style: GoogleFonts.poppins(
                                fontSize: 18.0,
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.w600),
                            children: [
                              TextSpan(
                                  text: ' Signup',
                                  // style: TextStyles.link,
                                  style: GoogleFonts.poppins(
                                      fontSize: 18.0,
                                      color: Colors.amber,
                                      fontWeight: FontWeight.w600),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap =
                                        () => Navigator.pushNamed(context, '/signup'))
                            ])),
                  ),
                ],
              ),
            ),
          ],
        ),
      // ),
    );
  }

///=======Old Code===============
  // Widget pageBody(BuildContext context, AuthBloc authBloc) {
  //   return ListView(
  //     // padding: EdgeInsets.all(0.0),
  //     children: <Widget>[
  //       Container(
  //         height: MediaQuery
  //             .of(context)
  //             .size
  //             .height * .2,
  //         decoration: BoxDecoration(
  //             image: DecorationImage(
  //                 image: AssetImage('assets/images/top_bg.png'),
  //                 fit: BoxFit.fill)),
  //       ),
  //       Container(
  //         height: 200.0,
  //         decoration: BoxDecoration(
  //           image: DecorationImage(
  //               image: AssetImage('assets/images/BBS-Logo-FinalOne.png')),
  //         ),
  //       ),
  //
  //       StreamBuilder<String>(
  //           stream: authBloc.email,
  //           builder: (context, snapshot) {
  //             return AppTextField(
  //               isIOS: Platform.isIOS,
  //               hintText: 'Email',
  //               cupertinoIcon: CupertinoIcons.mail_solid,
  //               materialIcon: Icons.email,
  //               textInputType: TextInputType.emailAddress,
  //               errorText: snapshot.error,
  //               onChanged: authBloc.changeEmail,
  //             );
  //           }),
  //       StreamBuilder<String>(
  //           stream: authBloc.password,
  //           builder: (context, snapshot) {
  //             return AppTextField(
  //               isIOS: Platform.isIOS,
  //               hintText: 'Password',
  //               materialIcon: Icons.lock,
  //               obscureText: true,
  //               errorText: snapshot.error,
  //               onChanged: authBloc.changePassword,
  //             );
  //           }),
  //       StreamBuilder<bool>(
  //           stream: authBloc.isValidLogin,
  //           ///Added Seperate Logic
  //           builder: (context, snapshot) {
  //             return AppButton(
  //               buttonText: 'Login',
  //               buttonType: (snapshot.data == true)
  //                   ? ButtonType.LightBlue
  //                   : ButtonType.Disabled,
  //               onPressed: () {
  //                 authBloc.loginEmail();
  //
  //                 ///Flutter Toast
  //                 Fluttertoast.showToast(
  //                     msg: "Hold On, Logging you in...",
  //                     toastLength: Toast.LENGTH_LONG,
  //                     gravity: ToastGravity.CENTER,
  //                     backgroundColor: Colors.teal,
  //                     textColor: Colors.white,
  //                     fontSize: 22.0,
  //                 );
  //               },
  //             );
  //           }),
  //       SizedBox(
  //         height: 25.0,
  //       ),
  //
  //       ///Google Signin
  //       // Center(
  //       //   child: Text('Or', style: GoogleFonts.mcLaren(
  //       //       fontSize: 20.0, fontWeight: FontWeight.bold)),
  //       // ),
  //       // SizedBox(
  //       //   height: 6.0,
  //       // ),
  //       // Padding(
  //       //   padding: BaseStyles.listPadding,
  //       //   child: Row(
  //       //     mainAxisAlignment: MainAxisAlignment.center,
  //       //     children: <Widget>[
  //       //       // AppSocialButton(
  //       //       //   socialType: SocialType.Facebook,
  //       //       // ),
  //       //       SizedBox(width: 15.0),
  //       //       InkWell(
  //       //         child: Center(
  //       //           child: AppSocialButton(socialType: SocialType.Google),
  //       //         ),
  //       //         onTap: authBloc.signinGoogle,
  //       //       ),
  //       //     ],
  //       //   ),
  //       // ),
  //
  //
  //       Padding(
  //         padding: BaseStyles.listPadding,
  //         child: RichText(
  //             textAlign: TextAlign.center,
  //             text: TextSpan(
  //                 text: 'New Here? ',
  //                 style: TextStyles.body,
  //                 children: [
  //                   TextSpan(
  //                       text: 'Signup',
  //                       style: TextStyles.link,
  //                       recognizer: TapGestureRecognizer()
  //                         ..onTap =
  //                             () => Navigator.pushNamed(context, '/signup'))
  //                 ])),
  //       )
  //     ],
  //   );
  // }
}

