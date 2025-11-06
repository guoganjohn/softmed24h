import 'package:json_annotation/json_annotation.dart';
import 'package:softmed24h/src/data/models/user.dart';

part 'medical_record.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MedicalRecordBase {
  final DateTime recordDate;
  final String diagnosis;
  final String treatment;

  MedicalRecordBase({
    required this.recordDate,
    required this.diagnosis,
    required this.treatment,
  });

  factory MedicalRecordBase.fromJson(Map<String, dynamic> json) =>
      _$MedicalRecordBaseFromJson(json);
  Map<String, dynamic> toJson() => _$MedicalRecordBaseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MedicalRecordCreate extends MedicalRecordBase {
  final int patientId;

  MedicalRecordCreate({
    required super.recordDate,
    required super.diagnosis,
    required super.treatment,
    required this.patientId,
  });

  factory MedicalRecordCreate.fromJson(Map<String, dynamic> json) =>
      _$MedicalRecordCreateFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MedicalRecordCreateToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MedicalRecord extends MedicalRecordBase {
  final int id;
  final User patient;

  MedicalRecord({
    required super.recordDate,
    required super.diagnosis,
    required super.treatment,
    required this.id,
    required this.patient,
  });

  factory MedicalRecord.fromJson(Map<String, dynamic> json) =>
      _$MedicalRecordFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MedicalRecordToJson(this);
}
