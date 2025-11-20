import 'package:equatable/equatable.dart';

class Category extends Equatable{
  final String img;
  final String name;
  final String id;
  final String status;
  final List<CategoryItem> itemList;

  const Category(
      {required this.img,
      required this.name,
      required this.id,
        required this.itemList,
      required this.status});

  factory Category.fromJson(Map<String,dynamic> json) {
    return Category(
      img: json['img'] ?? '',
      name: json['name'] ?? '',
      id: json['id'] ?? '',
      status: json['status'] ?? '',
      itemList: (json['items'] as List?)?.map((e)=> CategoryItem.fromJson(e as Map<String,dynamic>)).toList() ?? [],
    );
  }

  Map<String,dynamic> toJson() => {
    'id': id,
    'img': img,
    'name': name,
    'status': status,
    'items': itemList.map((e)=> e.toJson()).toList(),
  };

  @override
  List<Object?> get props => [img,name,id,status,itemList];

}

class CategoryItem extends Equatable{
  final String img;
  final String name;
  final String id;
  final String status;

  const CategoryItem(
      {required this.img,
        required this.name,
        required this.id,
        required this.status});

  factory CategoryItem.fromJson(Map<String,dynamic> json) {
    return CategoryItem(
      img: json['img'] ?? '',
      name: json['name'] ?? '',
      id: json['id'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String,dynamic> toJson() => {
    'id': id,
    'img': img,
    'name': name,
    'status': status,
  };

  @override
  List<Object?> get props => [img,name,id,status];
}
