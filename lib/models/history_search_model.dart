import 'package:equatable/equatable.dart';

class HistorySearch extends Equatable {

  final int? id;
  final String name;

  const HistorySearch({
    this.id,
    required this.name,
});

  HistorySearch.fromMap(Map<String, dynamic> his)
      : id = his["id"],
        name = his["name"];

  Map<String, Object?> toMap() {
    return {'id':id,'name': name};
  }

  @override
  List<Object?> get props => [id,name];

}