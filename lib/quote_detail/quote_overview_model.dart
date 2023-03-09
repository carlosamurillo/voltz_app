import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class QuoteOverviewModel {
  String? id;
  int? consecutive;
  String? alias;
  Timestamp? createdAt;
  Timestamp? publishedAt;
  bool accepted = false;

  convertTimestampToLocal(Timestamp date) {
    var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date.toDate().toUtc().toString(), true);
    return dateTime.toLocal();
  }

  QuoteOverviewModel({
    this.id,
    this.consecutive,
    this.alias,
    this.createdAt,
    this.publishedAt,
    this.accepted = false,
  });

  QuoteOverviewModel.fromJson(Map<String, dynamic> json, String docId) {
    id = docId;
    consecutive = json['consecutive'];
    alias = json['alias'];
    createdAt = json['created_at'];
    if (json.containsKey('published_at')) {
      publishedAt = json['published_at'];
    }
    accepted = json['accepted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['consecutive'] = this.consecutive;
    data['alias'] = this.alias;
    data['created_at'] = this.createdAt;
    if (this.publishedAt != null) {
      data['published_at'] = this.publishedAt;
    }
    data['accepted'] = this.accepted;
    return data;
  }
}