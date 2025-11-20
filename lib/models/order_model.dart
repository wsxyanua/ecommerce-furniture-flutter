import 'package:equatable/equatable.dart';

import 'cart_model.dart';

class OrderModel extends Equatable {
  final String idOrder;
  final String fullName;
  final String phone;
  final String country;
  final String city;
  final String address;
  final String note;
  final DateTime dateOrder;
  final String paymentMethod;
  final String statusPayment;
  final double subTotal;
  final double vat;
  final double deliveryFee;
  final double totalOrder;
  final String statusOrder;
  final String idUser;
  final List<Cart> cartList;

  const OrderModel({
    required this.cartList,
    required this.idUser,
    required this.paymentMethod,
    required this.fullName,
    required this.address,
    required this.city,
    required this.country,
    required this.dateOrder,
    required this.deliveryFee,
    required this.idOrder,
    required this.note,
    required this.phone,
    required this.statusOrder,
    required this.statusPayment,
    required this.subTotal,
    required this.totalOrder,
    required this.vat,
  });

  @override
  List<Object?> get props => [
    cartList,
    idUser,
    paymentMethod,
    fullName,
    address,
    city,
    country,
    dateOrder,
    deliveryFee,
    idOrder,
    note,
    phone,
    statusOrder,
    statusPayment,
    subTotal,
    totalOrder,
    vat
  ];

  Map<String, Object?> toMap() {
    return {

   factory OrderModel.fromJson(Map<String, dynamic> json) {
     return OrderModel(
       idUser: json['idUser'] ?? json['id_user'] ?? '',
       paymentMethod: json['paymentMethod'] ?? json['payment_method'] ?? '',
       fullName: json['fullName'] ?? json['full_name'] ?? '',
       address: json['address'] ?? '',
       city: json['city'] ?? '',
       country: json['country'] ?? '',
       dateOrder: _toDate(json['dateOrder'] ?? json['date_order']),
       deliveryFee: _toDouble(json['deliveryFee'] ?? json['delivery_fee']),
       idOrder: json['idOrder'] ?? json['id'] ?? '',
       note: json['note'] ?? '',
       phone: json['phone'] ?? '',
       statusOrder: json['statusOrder'] ?? json['status_order'] ?? '',
       statusPayment: json['statusPayment'] ?? json['status_payment'] ?? '',
       subTotal: _toDouble(json['subTotal'] ?? json['sub_total']),
       totalOrder: _toDouble(json['totalOrder'] ?? json['total_order']),
       vat: _toDouble(json['vat']),
       cartList: (json['items'] as List?)?.map((e) => Cart.fromJson(e as Map<String,dynamic>)).toList() ?? [],
     );
   }

   Map<String, dynamic> toJson() => {
         'id': idOrder,
         'id_user': idUser,
         'payment_method': paymentMethod,
         'full_name': fullName,
         'address': address,
         'city': city,
         'country': country,
         'date_order': dateOrder.toIso8601String(),
         'delivery_fee': deliveryFee,
         'note': note,
         'phone': phone,
         'status_order': statusOrder,
         'status_payment': statusPayment,
         'sub_total': subTotal,
         'total_order': totalOrder,
         'vat': vat,
         'items': cartList.map((e) => e.toJson()).toList(),
       };

   double _toDouble(dynamic v) {
     if (v == null) return 0;
     if (v is num) return v.toDouble();
     return double.tryParse(v.toString()) ?? 0;
   }

   DateTime _toDate(dynamic v) {
     if (v == null) return DateTime.fromMillisecondsSinceEpoch(0);
     if (v is DateTime) return v;
     if (v is String) return DateTime.tryParse(v) ?? DateTime.fromMillisecondsSinceEpoch(0);
     return DateTime.fromMillisecondsSinceEpoch(0);
   }
      'idUser': idUser,
      'paymentMethod': paymentMethod,
      'fullName': fullName,
      'city': city,
      'address': address,
      'country': country,
      'dateOrder': dateOrder,
      'deliveryFee': deliveryFee,
      'idOrder': idOrder,
      'note': note,
      'phone': phone,
      'statusOrder': statusOrder,
      'statusPayment': statusPayment,
      'subTotal':subTotal,
      'totalOrder':totalOrder,
      'vat':vat
    };
  }
}
