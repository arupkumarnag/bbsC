import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FAQSection extends StatefulWidget {
  @override
  _FAQSectionState createState() => _FAQSectionState();
}

class _FAQSectionState extends State<FAQSection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Center(
          child: Text('F A Q', style: GoogleFonts.poppins(
              fontSize: 19.0, fontWeight: FontWeight.w600)),
        ),
      ),

      body: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 15.0,),
          Center(
              child: Text(
                'Frequently Answered Questions',
                style: GoogleFonts.poppins(fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.black),
              )),
          Divider(
            color: Colors.amber,
            thickness: 1.0,
          ),
          SizedBox(height: 5.0,),

          SizedBox(height: 10.0,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '01. All products sold here are 100% Original and Authentic. ',
              style: GoogleFonts.poppins(
                  fontSize: 18.0, fontWeight: FontWeight.w500),
            ),
          ),

          Divider(color: Colors.teal, thickness: 1.0,),

          SizedBox(height: 10.0,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '02. We accept Cash on Delivery for now.',
              style: GoogleFonts.poppins(
                  fontSize: 18.0, fontWeight: FontWeight.w500),
            ),
          ),
          Divider(color: Colors.teal, thickness: 1.0,),

          SizedBox(height: 10.0,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '03. Minimum Order Value for free home delivery is : ',
              style: GoogleFonts.poppins(
                  fontSize: 18.0, fontWeight: FontWeight.w500),
            ),
          ),
          ///Stream Builder
          Center(
            child: SizedBox(
              height: 25, width: 80,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('delivery_charge')
                      .where('codId', isEqualTo: 'setId').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if(!snapshot.hasData){
                      return Center(child: CircularProgressIndicator());
                    }
                    return ListView(
                      children: snapshot.data.docs.map((document) {
                        return Text(
                          '₹ ${document['minOrderValue']}', style: GoogleFonts.roboto
                          (fontSize: 22.0, fontWeight: FontWeight.w600),);
                      }).toList(),
                    );
                  }
              ),
            ),
          ),
          Divider(color: Colors.teal, thickness: 1.0,),

          SizedBox(height: 10.0,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '04. Delivery Charges applicable for orders below minimum value is : ',
              style: GoogleFonts.poppins(
                  fontSize: 18.0, fontWeight: FontWeight.w500),
            ),
          ),
          ///Stream Builder
          Center(
            child: SizedBox(
              height: 25, width: 80,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('delivery_charge')
                      .where('codId', isEqualTo: 'setId').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if(!snapshot.hasData){
                      return Center(child: CircularProgressIndicator());
                    }
                    return ListView(
                      children: snapshot.data.docs.map((document) {
                        return Text(
                          '₹ ${document['deliveryCharge']}', style: GoogleFonts.roboto
                          (fontSize: 22.0, fontWeight: FontWeight.w600),);
                      }).toList(),
                    );
                  }
              ),
            ),
          ),
          Divider(color: Colors.teal, thickness: 1.0,),

          SizedBox(height: 10.0,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '05. For any Queries, Cancellation or Refund issues, contact us.',
              style: GoogleFonts.poppins(
                  fontSize: 18.0, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
