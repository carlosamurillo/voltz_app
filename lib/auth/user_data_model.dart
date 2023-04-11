import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UserData {
  String? companyName;
  DateTime? created;
  String email;
  String fullName;
  String lastName;
  String phone;
  String? photoURL;
  String role;
  String? trengoId;
  String? profileUserId;
  Record? record = Record();

  UserData({
    this.companyName,
    this.created,
    required this.email,
    required this.fullName,
    required this.lastName,
    required this.phone,
    this.photoURL,
    required this.role,
    this.trengoId,
    this.profileUserId,
  });

  factory UserData.initial() => UserData(
        companyName: "",
        created: DateTime.now(),
        email: "",
        fullName: "",
        lastName: "",
        phone: "",
        role: "",
        profileUserId: "",
      );

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        companyName: json['company_name'],
        created: convertTimestampToLocal(json['created'] as Timestamp),
        email: json['email'],
        fullName: json['full_name'],
        lastName: json['last_name'] ?? '',
        phone: json['phone'],
        photoURL: json['photo_URL'],
        role: json['role'],
        trengoId: json['trengo_id'],
        profileUserId: json['profile_user_id'],
      );

  UserData copyWith({
    String? companyName,
    DateTime? created,
    String? email,
    String? fullName,
    String? lastName,
    String? phone,
    String? photoURL,
    String? role,
    String? trengoId,
    String? profileUserId,
  }) =>
      UserData(
        companyName: companyName ?? this.companyName,
        created: created ?? this.created,
        email: email ?? this.email,
        fullName: fullName ?? this.fullName,
        lastName: lastName ?? this.lastName,
        phone: phone ?? this.phone,
        photoURL: photoURL ?? this.photoURL,
        role: role ?? this.role,
        trengoId: trengoId ?? this.trengoId,
        profileUserId: profileUserId ?? this.profileUserId,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_name'] = this.companyName;
    data['created'] = this.created;
    data['email'] = this.email;
    data['full_name'] = this.fullName;
    data['last_name'] = this.lastName;
    data['phone'] = this.phone;
    data['photo_URL'] = this.photoURL;
    data['role'] = this.role;
    data['trengo_id'] = this.trengoId;
    data['profile_user_id'] = this.profileUserId;
    return data;
  }
}

DateTime convertTimestampToLocal(Timestamp date) {
  var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date.toDate().toUtc().toString(), true);
  return dateTime.toLocal();
}

class Record {
  String? nextAction;
  Record({this.nextAction});

  Record.fromJson(Map<String, dynamic> json) {
    nextAction = json['next_action'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['next_action'] = this.nextAction;
    return data;
  }
}