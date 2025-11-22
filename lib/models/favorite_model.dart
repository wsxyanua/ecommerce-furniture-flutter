import 'package:equatable/equatable.dart';

class Favorite extends Equatable{
  final String idProduct;
  final String nameProduct;
  final String imgProduct;
  final int? idFavorite;
  final double price;

  const Favorite({
    this.idFavorite,
    required this.imgProduct,
    required this.nameProduct,
    required this.idProduct,
    required this.price,
  });

  Favorite.fromMap(Map<String, dynamic> cart)
      : idFavorite = cart["idFavorite"],
        idProduct = cart["idProduct"],
        nameProduct = cart["nameProduct"],
        imgProduct = cart["imgProduct"],
        price = cart["price"];

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      idFavorite: json['id'] as int? ?? json['idFavorite'] as int?,
      imgProduct: json['img'] ?? json['imgProduct'] ?? '',
      nameProduct: json['name'] ?? json['nameProduct'] ?? '',
      idProduct: json['product_id'] ?? json['idProduct'] ?? '',
      price: (json['price'] is num) 
        ? (json['price'] as num).toDouble() 
        : (json['price'] is String 
          ? double.tryParse(json['price']) ?? 0.0 
          : 0.0),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': idFavorite,
    'img': imgProduct,
    'name': nameProduct,
    'product_id': idProduct,
    'price': price.toString(),
  };

  Map<String, Object?> toMap() {
    return {'idFavorite':idFavorite,'idProduct': idProduct, 'nameProduct':nameProduct , 'imgProduct':imgProduct, 'price': price};
  }

  @override
  List<Object?> get props => [idProduct,imgProduct,nameProduct,price , idFavorite];
}
