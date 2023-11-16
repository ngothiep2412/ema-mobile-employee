// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ModelTestAttendance {
  String type;
  int number;
  ModelTestAttendance({
    required this.type,
    required this.number,
  });

  ModelTestAttendance copyWith({
    String? type,
    int? number,
  }) {
    return ModelTestAttendance(
      type: type ?? this.type,
      number: number ?? this.number,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'number': number,
    };
  }

  factory ModelTestAttendance.fromMap(Map<String, dynamic> map) {
    return ModelTestAttendance(
      type: map['type'] as String,
      number: map['number'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ModelTestAttendance.fromJson(String source) =>
      ModelTestAttendance.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ModelTestAttendance(type: $type, number: $number)';

  @override
  bool operator ==(covariant ModelTestAttendance other) {
    if (identical(this, other)) return true;

    return other.type == type && other.number == number;
  }

  @override
  int get hashCode => type.hashCode ^ number.hashCode;
}
