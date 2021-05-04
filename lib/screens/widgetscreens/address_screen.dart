import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_client_reboot/blocs/auth_bloc.dart';
import 'package:grocery_client_reboot/models/application_user.dart';
import 'package:grocery_client_reboot/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'dart:core';

class SetAddress extends StatefulWidget {
  @override
  _SetAddressState createState() => _SetAddressState();
}

class _SetAddressState extends State<SetAddress> {
  @override
  Widget build(BuildContext context) {
 
    final uid = Provider.of<ProductService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(
          'Manage Your Address', style: GoogleFonts.poppins(fontSize: 22.0),)),
      ),
      body: StreamBuilder<List<ApplicationUser>>(
          stream: uid.fetchUserData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());

            ///Fix for length.null error
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  var user = snapshot.data[index];
                  return Column(
                    children: <Widget>[
                      SizedBox(height: 12.0),
                      Card(
                        elevation: 15.0,
                        color: Colors.teal,
                        shadowColor: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            children: [
                              SizedBox(height: 10.0,),

                              Text(
                                'Email - ${user.email}',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20.0),
                              ),
                              SizedBox(height: 10.0,),
                              Text(
                                'Name - ${user.name}',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20.0),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                'Phone- ${user.contact}',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20.0),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Delivery Address - ${user.address}',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20.0),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  TextButton(
                                    child: Text(
                                      'Update',
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0, color: Colors.white),
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pushNamed(
                                            '/addresspage/${user.userId}'),
                                  ),
                                  SizedBox(width: 8),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                });
          }),
    );
  }
}
  
