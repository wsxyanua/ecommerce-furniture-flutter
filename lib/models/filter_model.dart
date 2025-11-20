import 'package:equatable/equatable.dart';

class FilterModel extends Equatable {
  final String idFilter;
  final List<String> price;
  final Map<String,String> color;
  final List<String> feature;
  final List<String> material;
  final List<String> popularSearch;
  final Map<String,dynamic> priceRange;
  final List<String> series;
  final List<String> sortBy;
  final String category;

  const FilterModel({
    required this.price,
    required this.color,
    required this.material,
    required this.feature,
    required this.idFilter,
    required this.popularSearch,
    required this.priceRange,
    required this.series,
    required this.sortBy,
    required this.category,
});

  factory FilterModel.fromJson(Map<String,dynamic> json) {
    return FilterModel(
      price: (json['price'] as List?)?.map((e)=> e.toString()).toList() ?? [],
      color: (json['color'] is Map<String,dynamic>) ? (json['color'] as Map<String,dynamic>).map((k,v)=> MapEntry(k,v.toString())) : {},
      material: (json['material'] as List?)?.map((e)=> e.toString()).toList() ?? [],
      feature: (json['feature'] as List?)?.map((e)=> e.toString()).toList() ?? [],
      idFilter: json['id'] ?? json['idFilter'] ?? '',
      popularSearch: (json['popular_search'] as List?)?.map((e)=> e.toString()).toList() ?? [],
      priceRange: (json['price_range'] is Map<String,dynamic>) ? json['price_range'] as Map<String,dynamic> : {},
      series: (json['series'] as List?)?.map((e)=> e.toString()).toList() ?? [],
      sortBy: (json['sort_by'] as List?)?.map((e)=> e.toString()).toList() ?? [],
      category: json['category'] ?? '',
    );
  }

  Map<String,dynamic> toJson() => {
    'id': idFilter,
    'price': price,
    'color': color,
    'material': material,
    'feature': feature,
    'popular_search': popularSearch,
    'price_range': priceRange,
    'series': series,
    'sort_by': sortBy,
    'category': category,
  };

  @override
  List<Object?> get props => [category,idFilter,price,color,feature,material,popularSearch,priceRange,series,sortBy];

}