///Model for authenticating the users from Firebase
///Added the address parameter

class ApplicationUser {
  final String userId;
  final String email;
  final String address;
  final String name;
  final String contact;


  ApplicationUser({
    this.email,
    this.userId,
    this.address,
    this.name, this.contact,
  });

  Map<String,dynamic> toMap(){
    return {
      'userId': userId,
      'email': email,
      'address': address,
      'phone': contact,
      'name' : name,
    };
  }

  ///New Syntax
  factory ApplicationUser.fromFirestore(Map<String, dynamic> firestore) {
    if (firestore == null) return null;

    return ApplicationUser(
        userId: firestore['userId'],
        email: firestore['email'],
        address: firestore['address'],
        name: firestore['name'],
        contact: firestore['phone'],
    );
  }

  // ApplicationUser.fromFirestore(Map<String,dynamic> firestore)
  //     : userId = firestore['userId'],
  //       email = firestore['email'];
}