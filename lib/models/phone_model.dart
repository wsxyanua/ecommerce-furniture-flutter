import 'package:equatable/equatable.dart';

class PhoneNumber extends Equatable{
  final String name;
  final String value;
  final String format;
  final int digit;

  const PhoneNumber({
   required this.name,
    required this.value,
    required this.format,
    required this.digit,
});

  @override
  // TODO: implement props
  List<Object?> get props => [name,value,format,digit];
}