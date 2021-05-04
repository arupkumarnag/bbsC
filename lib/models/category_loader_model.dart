import 'package:flutter/foundation.dart';

class CategoryLoaderProducts with ChangeNotifier{
  final String id; 
  final String name;
  final String imgUrl;


  CategoryLoaderProducts(
      {@required this.id,
        @required this.name,
        @required this.imgUrl,
      });
}

///Class to define the list of our products

class Products with ChangeNotifier{
  List<CategoryLoaderProducts> _items = [
    CategoryLoaderProducts(
      id: '1',
      name: 'Biscuits & Cookies',
      imgUrl:
        'assets/images/biscuits.jpg',
      
    ),
    CategoryLoaderProducts(
      id: '2',
      name: 'Chocolate & Honey',
      imgUrl: 'assets/images/chocolate-honey.jpg',
  
    ),
    CategoryLoaderProducts(
      id: '3',
      name: 'Milk & Dairy',
      imgUrl:'assets/images/dairy.jpg',
      
    ),
    CategoryLoaderProducts(
      id: '4',
      name: 'Ketchup & Mayo',
      imgUrl:
      'assets/images/ketchup-mayo.jpg',
    ),
    CategoryLoaderProducts(
      id: '5',
      name: 'Noodle & Snacks',
      imgUrl:
      'assets/images/noodles-snacks.jpg',
    ),
    CategoryLoaderProducts(
      id: '6',
      name: 'Rice & Pulses',
      imgUrl: 'assets/images/rice.jpg',
  
    ),
    CategoryLoaderProducts(
      id: '7',
      name: 'Spices & More',
      imgUrl: 'assets/images/spices.jpg',
    ),
    CategoryLoaderProducts(
      id: '8',
      name: 'Tea & Coffee',
      imgUrl: 'assets/images/tea-coffee.jpg',
    ),
  ];

  List<CategoryLoaderProducts> get items {
    return [..._items];
  }

  CategoryLoaderProducts findById(String id) {
    return _items.firstWhere((pdt) => pdt.id == id);
  }

}
