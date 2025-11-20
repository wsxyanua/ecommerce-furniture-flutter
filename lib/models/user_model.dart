import 'package:equatable/equatable.dart';

class UserSQ extends Equatable {
  final String phone;
  final String fullName;
  final String address;
  final String img;
  final String birthDate;
  final String idUser;
  final String dateEnter;
  final String email;
  final String status;
  final String gender;

  const UserSQ({
    required this.status,
    required this.email,
    required this.phone,
    required this.fullName,
    required this.address,
    required this.img,
    required this.birthDate,
    required this.idUser,
    required this.dateEnter,
    required this.gender,
  });

  UserSQ.fromMap(Map<String, dynamic> user)
      : idUser = user["idUser"],
        email = user["email"],
        phone = user["phone"],
        fullName = user["fullName"],
        address = user["address"],
        img = user["img"],
        gender = user['gender'],
        birthDate = user["birthDate"],
        dateEnter = user["dateEnter"],
        status = user["status"];

  Map<String, Object?> toMap() {
    return {
      'idUser': idUser,
      'email': email,
      'phone': phone,
      'fullName': fullName,
      'address': address,
      'img': img,
      'birthDate': birthDate,
      'dateEnter': dateEnter,
      'status': status,
      'gender': gender,
    };
  }

  factory UserSQ.fromJson(Map<String, dynamic> json) {
    return UserSQ(
      status: json['status'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      fullName: json['full_name'] ?? json['fullName'] ?? '',
      address: json['address'] ?? '',
      img: json['img'] ?? '',
      birthDate: json['birth_date'] ?? json['birthDate'] ?? '',
      idUser: json['id'] ?? json['idUser'] ?? '',
      dateEnter: json['date_enter'] ?? json['dateEnter'] ?? '',
      gender: json['gender'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': idUser,
        'email': email,
        'phone': phone,
        'full_name': fullName,
        'address': address,
        'img': img,
        'birth_date': birthDate,
        'date_enter': dateEnter,
        'status': status,
        'gender': gender,
      };

  @override
  List<Object?> get props => [
        status,
        email,
        phone,
        fullName,
        address,
        img,
        birthDate,
        idUser,
        dateEnter,
        gender,
      ];
}
