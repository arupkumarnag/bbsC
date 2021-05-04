import 'dart:async';
import 'package:grocery_client_reboot/models/application_user.dart';
import 'package:grocery_client_reboot/services/firestore_service.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

final RegExp regExpEmail = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

class AuthBloc {
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _name = BehaviorSubject<String>();
  final _deliveryAddress = BehaviorSubject<String>();
  final _contactNumber = BehaviorSubject<String>();
  final _user = BehaviorSubject<ApplicationUser>();
  final _errorMessage = BehaviorSubject<String>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ProductService _firestoreService = ProductService();
  final googleSignin = GoogleSignIn(scopes: ['email']);           
  final _userUpdated = PublishSubject<bool>();               
  final _userDataUpdate = BehaviorSubject<ApplicationUser>(); 
  final db = ProductService();

  ///Get Data
  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<String> get password => _password.stream.transform(validatePassword);
  Stream<String> get name => _name.stream.transform(validateUserName);
  Stream<String> get address => _deliveryAddress.stream.transform(validateAddress);
  Stream<String> get contact => _contactNumber.stream.transform(validateContactNumber);
  Stream<bool> get isValid => CombineLatestStream.combine5(email, password, name, address, contact, (a, b, c, d, e) => true);  
  Stream<bool> get isValidLogin => CombineLatestStream.combine2(email, password, (a, b) => true);   
  Stream<bool> get isUserDataUpdated => CombineLatestStream.combine3(name, address, contact, (a, b, c) => true);

  Stream<ApplicationUser> get user => _user.stream;
  Stream<String> get errorMessage => _errorMessage.stream;
  String get userId => _user.value.userId;

  Stream<List<ApplicationUser>> get fetchUserdata => db.fetchUserData();      ///Added for Fetching userdata

  Future<ApplicationUser> fetchAvailableUsers(String userId) =>
      db.fetchAvailableUsers(userId);

  Stream<bool> get userInfoData=> _userUpdated.stream;          

  ///Set Data
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;
  Function(String) get changeName => _name.sink.add;
  Function(String) get changeContact => _contactNumber.sink.add;
  Function(String) get changeAddress => _deliveryAddress.sink.add;
  Function(ApplicationUser) get changeUserInfo => _userDataUpdate.sink.add;      ///For User Data Update

  dispose() {
    _email.close();
    _password.close();
    _name.close();
    _deliveryAddress.close();
    _contactNumber.close();
    _user.close();
    _errorMessage.close();
    _userDataUpdate.close();
    _userUpdated.close();
  }

  ///========================Functions=============================

  ///To Save Updated & Edited User Values
  Future<void> saveEditUserValues() async {
    var edited = ApplicationUser(
      address: _deliveryAddress.value,
      contact: _contactNumber.value,      
      name: _name.value,
      email: _email.value,
      userId:
      (_user.value == null) ? Uuid().v4() : _user.value.userId,
    );

    return db
        .setUserNow(edited)
        .then((value) => _userUpdated.sink.add(true))
        .catchError((error) => _userUpdated.sink.add(false));
  }

 ///=====================Transformers=========================================
  final validateEmail =
  StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (regExpEmail.hasMatch(email.trim())) {
      sink.add(email.trim());
    } else {
      sink.addError('Must Be Valid Email Address');
    }
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
        if (password.length >= 8) {
          sink.add(password.trim());
        } else {
          sink.addError('8 Character Minimum');
        }
      });

  final validateUserName = StreamTransformer<String, String>.fromHandlers(
      handleData: (name, sink) {
        if (name.length >= 3) {
          sink.add(name.trim());
        } else {
          sink.addError('3 Character Minimum');
        }
      });

  final validateContactNumber = StreamTransformer<String, String>.fromHandlers(
      handleData: (contact, sink) {
        if (contact.length >= 10 && contact.length < 12) {
          sink.add(contact.trim());
        } else {
          sink.addError('Must be a valid Phone Number');
        }
      });

  final validateAddress = StreamTransformer<String, String>.fromHandlers(
      handleData: (address, sink) {
        if (address.length >= 20) {
          sink.add(address.trim());
        } else {
          sink.addError('20 Character Minimum');
        }
      });

  ///=======================Functions============================

  ///Signup with email

  signupEmail() async {
    print('Signing up with username and password & Other Details');

    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: _email.value.trim(), password: _password.value.trim());

      var user = ApplicationUser(     ///Added Later
          userId: authResult.user.uid, email: _email.value.trim(),
          name: _name.value.trim(), address: _deliveryAddress.value.trim(),
          contact: _contactNumber.value.trim(),
      );

      await _firestoreService.addUser(user);
      _user.sink.add(user);
    } catch (error){
      print(error);
      _errorMessage.sink.add(error.message);
    }

  }

  ///Login with email
  loginEmail() async {
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
          email: _email.value.trim(), password: _password.value.trim());
      var user = await _firestoreService.fetchUser(authResult.user.uid);
      _user.sink.add(user);
    } catch (error){
      print(error);
      _errorMessage.sink.add(error.message);
    }
  }

  ///Login with Google
  signinGoogle() async{

    //google login
    try {
      final GoogleSignInAccount googleUser = await googleSignin.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken
      );

      ///Signin to Firebase
      final result = await _auth.signInWithCredential(credential);

      ///Check if user already exists
      var existingUser = await _firestoreService.fetchUser(result.user.uid);
      var user = ApplicationUser(email: result.user.email, userId: result.user.uid);

      if (existingUser == null) {
        await _firestoreService.addUser(user);
        _user.sink.add(user);
      } else {
        _user.sink.add(user);
      }
    } catch (error){
      _errorMessage.sink.add('Google SignIn Failed');
      print(error.toString());
    }
  }

  ///Check user if already loggedin
  Future<bool> isLoggedIn() async {
    var firebaseUser = await _auth.currentUser;
    if (firebaseUser == null) return false;

    var user = await _firestoreService.fetchUser(firebaseUser.uid);
    if (user == null) return false;

    _user.sink.add(user);
    return true;
  }

  ///SignOut User
  logout() async {
    await _auth.signOut();
    _user.sink.add(null);
  }

  ///Clear Error Message
  clearErrorMessage(){
    _errorMessage.sink.add('');
  }
}
