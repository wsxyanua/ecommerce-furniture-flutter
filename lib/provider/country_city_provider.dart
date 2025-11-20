import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import '../services/api_service.dart';

class Country extends Equatable{
  late final String name;
  final String id;
  final List<String> city;

  Country({required this.name, required this.id, required this.city});

  @override
  List<Object> get props => [name, id,city];

  @override
  bool get stringify => false;

}

class CountryCityProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  List<Country> _countries = [];
  bool _loading = false;
  String? _error;

  Future<void> fetchCountries() async {
    _loading = true; _error = null; notifyListeners();
    try {
      _countries = await _api.fetchCountries();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false; notifyListeners();
    }
  }

  List<Country> get countries => _countries;
  bool get isLoading => _loading;
  String? get error => _error;
}
