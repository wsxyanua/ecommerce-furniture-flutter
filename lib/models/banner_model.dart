import 'package:equatable/equatable.dart';

class Banner1 extends Equatable{
  final String id;
  final String dateStart;
  final String dateEnd;
  final String imgURL;
  final String status;
  final List<String> product;

  const Banner1({
    required this.id,
    required this.dateEnd,
    required this.dateStart,
    required this.imgURL,
    required this.status,
    required this.product
  });

  factory Banner1.fromJson(Map<String,dynamic> json) {
    return Banner1(
      id: json['id'] ?? '',
      dateStart: json['date_start'] ?? json['dateStart'] ?? '',
      dateEnd: json['date_end'] ?? json['dateEnd'] ?? '',
      imgURL: json['img'] ?? json['imgURL'] ?? '',
      status: json['status'] ?? '',
      product: (json['product'] as List?)?.map((e)=> e.toString()).toList() ?? [],
    );
  }

  Map<String,dynamic> toJson() => {
    'id': id,
    'date_start': dateStart,
    'date_end': dateEnd,
    'img': imgURL,
    'status': status,
    'product': product,
  };

  @override
  List<Object?> get props => [id,dateStart,dateEnd,imgURL,status,product];
}
