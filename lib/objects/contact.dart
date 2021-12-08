import 'package:firebase_database/firebase_database.dart';

class Contact {
  Contact(this._id, this._name, this._phone, this._address);

  String? _id;
  String? _name;
  String? _phone;
  String? _address;

  Contact.map(dynamic obj){
    this!._name = obj['name'];
    this!._phone = obj['phone'];
    this!._address = obj['address'];
  }

  String? get id => _id;
  String? get name => _name;
  String? get phone => _phone;
  String? get address => _address;

  Contact.fromSnapShot(DataSnapshot snapshot){
    _id = snapshot.key;
    _name = snapshot.value['name'];
    _phone = snapshot.value['phone'];
    _address = snapshot.value['address'];
  }
}