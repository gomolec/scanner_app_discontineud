import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'session_model.g.dart';

@HiveType(typeId: 1)
class Session extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final DateTime startDate;
  @HiveField(2)
  final DateTime? endDate;
  @HiveField(3)
  final String? author;

  const Session({
    required this.id,
    required this.startDate,
    this.endDate,
    this.author,
  });

  Session copyWith({
    String? id,
    DateTime? startDate,
    DateTime? endDate,
    String? author,
  }) {
    return Session(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      author: author ?? this.author,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
      'author': author,
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      id: map['id'] ?? '',
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      endDate: map['endDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endDate'])
          : null,
      author: map['author'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Session.fromJson(String source) =>
      Session.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Session(id: $id, startDate: $startDate, endDate: $endDate, author: $author)';
  }

  @override
  List<Object?> get props => [id, startDate, endDate, author];
}
