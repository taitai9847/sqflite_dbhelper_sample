import 'package:sqflite_sample/models/table_fields.dart';

class Sample {
  final int? id;
  final String title;

  Sample({
    this.id,
    required this.title,
  });

  Sample copy({
    int? id,
    String? title,
  }) =>
      Sample(
        id: this.id,
        title: this.title,
      );

  static Sample fromJson(Map<String, Object?> json) => Sample(
        id: json[TableFields.id] as int,
        title: json[TableFields.title] as String,
      );

  Map<String, Object?> toJson() => {
        TableFields.id: id,
        TableFields.title: title,
      };
}
