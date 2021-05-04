import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_client_reboot/blocs/auth_bloc.dart';
import 'package:grocery_client_reboot/styles/base.dart';
import 'package:grocery_client_reboot/widgets/button.dart';
import 'package:grocery_client_reboot/widgets/textfield.dart';
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  @override
  void initState() {
    final authBloc = Provider.of<AuthBloc>(context,listen: false);
    authBloc.user.listen((user) {
      if (user != null) Navigator.pushReplacementNamed(context, '/landing');
    });
    super.initState();
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
        padding: EdgeInsets.all(0.0),
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * .2,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/rainbow-edit.png'),

                    fit: BoxFit.fill)),
          ),

          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * .2,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/bbs-ring-logo.png')),
                  ),
                ),
                StreamBuilder<String>(
                    stream: authBloc.name,
                    builder: (context, snapshot) {
                      return AppTextField(
                        isIOS: Platform.isIOS,
                        hintText: 'Your Name',
                        cupertinoIcon: CupertinoIcons.mail_solid,
                        materialIcon: Icons.person,
                        textInputType: TextInputType.text,
                        errorText: snapshot.error,
                        onChanged: authBloc.changeName,
                      );
                    }),
                StreamBuilder<String>(
                    stream: authBloc.address,
                    builder: (context, snapshot) {
                      return AppTextField(
                        isIOS: Platform.isIOS,
                        hintText: 'Delivery Address',
                        cupertinoIcon: CupertinoIcons.mail_solid,
                        materialIcon: Icons.home_work,
                        textInputType: TextInputType.emailAddress,
                        errorText: snapshot.error,
                        onChanged: authBloc.changeAddress,
                      );
                    }),
                StreamBuilder<String>(
                    stream: authBloc.contact,
                    builder: (context, snapshot) {
                      return AppTextField(
                        isIOS: Platform.isIOS,
                        hintText: 'Contact Number',
                        cupertinoIcon: CupertinoIcons.mail_solid,
                        materialIcon: Icons.phone,
                        textInputType: TextInputType.number,
                        errorText: snapshot.error,
                        onChanged: authBloc.changeContact,
                      );
                    }),
                StreamBuilder<String>(
                    stream: authBloc.email,
                    builder: (context, snapshot) {
                      return AppTextField(
                        isIOS: Platform.isIOS,
                        hintText: 'Email',
                        cupertinoIcon: CupertinoIcons.mail_solid,
                        materialIcon: Icons.email,
                        textInputType: TextInputType.emailAddress,
                        errorText: snapshot.error,
                        onChanged: authBloc.changeEmail,
                        // validatorFirebase: ,
                      );
                    }),
                StreamBuilder<String>(
                    stream: authBloc.password,
                    builder: (context, snapshot) {
                      return AppTextField(
                        isIOS: Platform.isIOS,
                        hintText: 'Password',
                        materialIcon: Icons.lock,
                        obscureText: true,
                        errorText: snapshot.error,
                        onChanged: authBloc.changePassword,
                      );
                    }),
                StreamBuilder<bool>(
                    stream: authBloc.isValid,
                    builder: (context, snapshot) {
                      return AppButton(
                          buttonText: 'Signup',
                          buttonType: (snapshot.data == true)
                              ? ButtonType.LightBlue
                              : ButtonType.Disabled,
                          onPressed: () {
                            authBloc.signupEmail();

                            ///Flutter Toast
                            Fluttertoast.showToast(
                              msg: "Please Wait, while we sign you up !!!",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.blueAccent,
                              textColor: Colors.white,
                              fontSize: 20.0,
                            );
                          }
                      );
                    }),
                SizedBox(
                  height: 6.0,
                ),
                Padding(
                  padding: BaseStyles.listPadding,
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: 'Already Have an Account ? ',
                          // style: TextStyles.body,
                          style: GoogleFonts.poppins(
                              fontSize: 18.0,
                              color: Colors.amber,
                              fontWeight: FontWeight.w600),
                          children: [
                            TextSpan(
                                text: ' Login',
                                style: GoogleFonts.poppins(
                                    fontSize: 18.0,
                                    color: Colors.greenAccent,
                                    fontWeight: FontWeight.w600),

                                recognizer: TapGestureRecognizer()
                                  ..onTap =
                                      () => Navigator.pushNamed(context, '/login'))
                          ])),
                ),
              ],
            ),
          ),

          SizedBox(height: 15.0,),
        ],
      ),
    );
  }
}
