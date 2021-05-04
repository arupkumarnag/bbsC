import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_client_reboot/blocs/auth_bloc.dart';
import 'package:grocery_client_reboot/models/application_user.dart';
import 'package:grocery_client_reboot/styles/base.dart';
import 'package:grocery_client_reboot/styles/colors.dart';
import 'package:grocery_client_reboot/styles/text.dart';
import 'package:grocery_client_reboot/widgets/button.dart';
import 'package:grocery_client_reboot/widgets/sliver_scaffold.dart';
import 'package:grocery_client_reboot/widgets/textfield.dart';
import 'package:grocery_client_reboot/widgets/textfieldemail.dart';
import 'package:provider/provider.dart';

class UserDataEdit extends StatefulWidget {
  final String userId;

  UserDataEdit({this.userId});

  @override
  _UserDataEditState createState() => _UserDataEditState();

  }

class _UserDataEditState extends State<UserDataEdit> {

  @override
  void initState() {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);

    authBloc.userInfoData.listen((saved) {
      if (saved != null && saved == true && context != null) {
        Fluttertoast.showToast(
          msg: "Changes Saved",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.lightblue,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        ///Page Redirect
        Navigator.of(context).pushNamed('/addresspage');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var authBloc = Provider.of<AuthBloc>(context);

    return FutureBuilder<ApplicationUser>(
      future: authBloc.fetchAvailableUsers(widget.userId),      ///Edit here- Watch
      builder: (context, snapshot) {
        if (!snapshot.hasData && widget.userId != null) {         ///Watch Here
          return Center(child: CircularProgressIndicator());
        }

        ApplicationUser existingUser;

        if (widget.userId != null) { 

          existingUser = snapshot.data;
          loadValues(authBloc, existingUser);
        } else {
         
          loadValues(authBloc, null);
        }

        return AppSliverScaffold.materialSliverScaffold(
            navTitle: '',
            pageBody: pageBody(false, authBloc, context, existingUser),
            context: context);
      },
    );
  }

}

Widget pageBody(bool isIOS, AuthBloc authBloc, BuildContext context, ApplicationUser existingUser) {

  var pageLabel = (existingUser != null)
      ? 'Update Your Details'
      : 'Add Your Details';

  return ListView(
    children: <Widget>[
      Text(
        pageLabel,

        ///Shows Text
        style: TextStyles.subtitle,
        textAlign: TextAlign.center,
      ),
      Padding(
        padding: BaseStyles.listPadding,
        child: Divider(color: AppColors.darkblue),
      ),

      StreamBuilder<String>(
          stream: authBloc.name,
          builder: (context, snapshot) {
            return AppTextFieldEmail(
              hintText: 'Login Email',
              materialIcon: Icons.email_rounded,
              textInputType: TextInputType.emailAddress,
              isIOS: isIOS,
              errorText: snapshot.error,
              initialText: (existingUser != null)
                  ? existingUser.email
                  : null,
              onChanged: authBloc.changeEmail,
            );
          }),

      StreamBuilder<String>(
          stream: authBloc.name,
          builder: (context, snapshot) {
            return AppTextField(
              hintText: 'Name',
              materialIcon: Icons.person,
              textInputType: TextInputType.text,
              errorText: snapshot.error,
              initialText: (existingUser != null)
                  ? existingUser.name
                  : null,
              onChanged: authBloc.changeName, cupertinoIcon: null,
            );
          }),

      ///Added Product Description
      StreamBuilder<String>(
          stream: authBloc.contact,
          builder: (context, snapshot) {
            return AppTextField(
              hintText: 'Phone Number',
              cupertinoIcon: FontAwesomeIcons.stickyNote,
              materialIcon: Icons.phone,
              textInputType: TextInputType.number,
              isIOS: isIOS,
              errorText: snapshot.error,
              initialText: (existingUser != null)
                  ? existingUser.contact
                  : null,
              onChanged: authBloc.changeContact,
            );
          }),

      ///Added User Address
      StreamBuilder<String>(
          stream: authBloc.address,
          builder: (context, snapshot) {
            return AppTextField(
              hintText: 'Address',
              cupertinoIcon: FontAwesomeIcons.home,
              materialIcon: Icons.home_work,
              isIOS: isIOS,
              errorText: snapshot.error,
              initialText: (existingUser != null)
                  ? existingUser.address
                  : null,
              onChanged: authBloc.changeAddress,
            );
          }),


      StreamBuilder<bool>(
          stream: authBloc.isUserDataUpdated,
          builder: (context, snapshot) {
            return AppButton(
              buttonType: (snapshot.data == true)
                  ? ButtonType.DarkBlue
                  : ButtonType.Disabled,
              buttonText: 'Save Details',
              onPressed: authBloc.saveEditUserValues,
            );
          }),
    ],
  );
}

loadValues(AuthBloc authBloc, ApplicationUser applicationUser) {
  authBloc.changeUserInfo(applicationUser);

  if (applicationUser != null) {
    ///Edit
    authBloc.changeName(applicationUser.name);
    authBloc.changeAddress(applicationUser.address);
    authBloc.changeContact(applicationUser.contact);
    authBloc.changeEmail(applicationUser.email);

  } else {
    ///Add
    authBloc.changeName(null);
    authBloc.changeContact(null);
    authBloc.changeAddress(null);
    authBloc.changeEmail(null);
  }
}

