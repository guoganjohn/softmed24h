import 'package:json_annotation/json_annotation.dart';
import 'package:softmed24h/src/data/models/user.dart';

part 'prescription.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PrescriptionBase {
  final DateTime prescriptionDate;
  final String medication;
  final String dosage;

  PrescriptionBase({
    required this.prescriptionDate,
    required this.medication,
    required this.dosage,
  });

  factory PrescriptionBase.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionBaseFromJson(json);
  Map<String, dynamic> toJson() => _$PrescriptionBaseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PrescriptionCreate extends PrescriptionBase {
  final int patientId;
  final int prescriberId;

  PrescriptionCreate({
    required super.prescriptionDate,
    required super.medication,
    required super.dosage,
    required this.patientId,
    required this.prescriberId,
  });

  factory PrescriptionCreate.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionCreateFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PrescriptionCreateToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Prescription extends PrescriptionBase {
  final int id;
  final User patient;
  final User prescriber;

  Prescription({
    required super.prescriptionDate,
    required super.medication,
    required super.dosage,
    required this.id,
    required this.patient,
    required this.prescriber,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PrescriptionToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CreatePrescriptionRequest {
  final String patientName;
  final List<Map<String, dynamic>> medicines;

  CreatePrescriptionRequest({
    required this.patientName,
    required this.medicines,
  });

  factory CreatePrescriptionRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePrescriptionRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreatePrescriptionRequestToJson(this);
}
