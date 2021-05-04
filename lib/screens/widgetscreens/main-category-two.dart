import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingCategoryTwo extends StatefulWidget {
  @override
  _LandingCategoryTwoState createState() => _LandingCategoryTwoState();
}

class _LandingCategoryTwoState extends State<LandingCategoryTwo> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GridView(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        physics: ScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => Navigator.of(context).pushNamed('/biscuit'),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: GridTile(
                  child: Image.asset('assets/images/biscuits.jpg'),
                  footer: GridTileBar(
                    title: Center(
                        child: Text('Biscuit',
                      style: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.w600)
                    )),
                    backgroundColor: Colors.black54,
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => Navigator.of(context).pushNamed('/ketchup'),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: GridTile(
                  child: Image.asset('assets/images/ketchup-mayo.jpg'),
                  footer: GridTileBar(
                    title: Center(
                        child: Text('Ketchup',
                          style: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.w600),
                        )),
                    backgroundColor: Colors.black54,
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => Navigator.of(context).pushNamed('/milk'),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: GridTile(
                  child: Image.asset('assets/images/dairy.jpg'),
                  footer: GridTileBar(
                    title: Center(
                        child: Text('Milk & Dairy',
                          style: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.w600),
                        )),
                    backgroundColor: Colors.black54,
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => Navigator.of(context).pushNamed('/noodles'),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: GridTile(
                  child: Image.asset('assets/images/noodles-snacks.jpg'),
                  footer: GridTileBar(
                    title: Center(
                        child: Text('Noodles',
                          style: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.w600),
                        )),
                    backgroundColor: Colors.black54,
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => Navigator.of(context).pushNamed('/rice'),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: GridTile(
                  child: Image.asset('assets/images/rice.jpg'),
                  footer: GridTileBar(
                    title: Center(
                        child: Text('Rice & Pulses',
                          style: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.w600),
                        )),
                    backgroundColor: Colors.black54,
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => Navigator.of(context).pushNamed('/chocolate'),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: GridTile(
                  child: Image.asset('assets/images/sugar.jpg'),
                  footer: GridTileBar(
                    title: Center(
                        child: Text('Salt & Sugar',
                          style: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.w600),
                        )),
                    backgroundColor: Colors.black54,
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => Navigator.of(context).pushNamed('/spices'),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: GridTile(
                  child: Image.asset('assets/images/spices.jpg'),
                  footer: GridTileBar(
                    title: Center(
                        child: Text('Spices & More',
                          style: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.w600),
                        )),
                    backgroundColor: Colors.black54,
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => Navigator.of(context).pushNamed('/tea'),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: GridTile(
                  child: Image.asset('assets/images/tea-coffee.jpg'),
                  footer: GridTileBar(
                    title: Center(
                        child: Text('Tea & Coffee',
                          style: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.w600),
                        )),
                    backgroundColor: Colors.black54,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
