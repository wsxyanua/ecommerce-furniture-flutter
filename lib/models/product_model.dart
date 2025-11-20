import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String img;
  final String title;
  final String description;
  final String status;
  final String categoryItemId;
  final Map<String, String> material;
  final Map<String, String> size;
  final double rootPrice;
  final double currentPrice;
  final double review;
  final double sellest;
  final List<ProductItem> productItemList;
  final List<Review> reviewList;
  final DateTime timestamp;

  const Product({
    required this.id,
    required this.name,
    required this.img,
    required this.title,
    required this.description,
    required this.status,
    required this.categoryItemId,
    required this.material,
    required this.size,
    required this.rootPrice,
    required this.currentPrice,
    required this.review,
    required this.sellest,
    required this.productItemList,
    required this.reviewList,
    required this.timestamp,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      img: json['img'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      categoryItemId: json['category_id']?.toString() ?? json['categoryItemId']?.toString() ?? '',
      material: (json['material'] is Map<String, dynamic>)
          ? (json['material'] as Map<String, dynamic>).map((k, v) => MapEntry(k, v.toString()))
          : {},
      size: (json['size'] is Map<String, dynamic>)
          ? (json['size'] as Map<String, dynamic>).map((k, v) => MapEntry(k, v.toString()))
          : {},
      rootPrice: _toDouble(json['root_price'] ?? json['rootPrice']),
      currentPrice: _toDouble(json['current_price'] ?? json['currentPrice']),
      review: _toDouble(json['review'] ?? json['review_avg']),
      sellest: _toDouble(json['sellest'] ?? json['sell_count']),
      productItemList: (json['items'] as List?)
              ?.map((e) => ProductItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      reviewList: (json['reviews'] as List?)
              ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      timestamp: _toDate(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'img': img,
      'title': title,
      'description': description,
      'status': status,
      'categoryItemId': categoryItemId,
      'material': material,
      'size': size,
      'rootPrice': rootPrice,
      'currentPrice': currentPrice,
      'review': review,
      'sellest': sellest,
      'items': productItemList.map((e) => e.toJson()).toList(),
      'reviews': reviewList.map((e) => e.toJson()).toList(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        img,
        title,
        description,
        status,
        categoryItemId,
        material,
        size,
        rootPrice,
        currentPrice,
        review,
        sellest,
        productItemList,
        reviewList,
        timestamp,
      ];
}

class ProductItem extends Equatable {
  final String id;
  final Map<String, String> color;
  final List<String> img;

  const ProductItem({
    required this.id,
    required this.color,
    required this.img,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      id: json['id'] ?? '',
      color: (json['color'] is Map<String, dynamic>)
          ? (json['color'] as Map<String, dynamic>).map((k, v) => MapEntry(k, v.toString()))
          : {},
      img: (json['img'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'color': color,
        'img': img,
      };

  @override
  List<Object?> get props => [id, color, img];
}

class Review extends Equatable {
  final String id;
  final String idUser;
  final String idOrder;
  final String message;
  final List<String> img;
  final DateTime date;
  final Map<String, dynamic> service;
  final double star;

  const Review({
    required this.id,
    required this.idUser,
    required this.idOrder,
    required this.message,
    required this.img,
    required this.date,
    required this.service,
    required this.star,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? '',
      idUser: json['idUser'] ?? json['user_id'] ?? '',
      idOrder: json['idOrder'] ?? json['order_id'] ?? '',
      message: json['message'] ?? '',
      img: (json['img'] as List?)?.map((e) => e.toString()).toList() ?? [],
      date: _toDate(json['timestamp'] ?? json['date']),
      service: (json['service'] is Map<String, dynamic>) ? json['service'] as Map<String, dynamic> : {},
      star: _toDouble(json['star']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'idUser': idUser,
        'idOrder': idOrder,
        'message': message,
        'img': img,
        'timestamp': date.toIso8601String(),
        'service': service,
        'star': star,
      };

  @override
  List<Object?> get props => [id, idUser, idOrder, message, img, date, service, star];
}

double _toDouble(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0;
}

DateTime _toDate(dynamic v) {
  if (v == null) return DateTime.fromMillisecondsSinceEpoch(0);
  if (v is DateTime) return v;
  if (v is String) {
    return DateTime.tryParse(v) ?? DateTime.fromMillisecondsSinceEpoch(0);
  }
  return DateTime.fromMillisecondsSinceEpoch(0);
}
