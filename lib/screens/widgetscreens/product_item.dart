import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_client_reboot/models/category_loader_model.dart';

import 'package:provider/provider.dart';

class PdtItem extends StatelessWidget {
  final String name;
  final String imageUrl;

  PdtItem({this.name, this.imageUrl});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: GridTile(
            child: Image.asset(imageUrl),
            footer: GridTileBar(
              title: Center(child: Text(name, style: GoogleFonts.acme(fontSize: 17.0),)),
              backgroundColor: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}
