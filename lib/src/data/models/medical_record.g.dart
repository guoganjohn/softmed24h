// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicalRecordBase _$MedicalRecordBaseFromJson(Map<String, dynamic> json) =>
    MedicalRecordBase(
      recordDate: DateTime.parse(json['record_date'] as String),
      diagnosis: json['diagnosis'] as String,
      treatment: json['treatment'] as String,
    );

Map<String, dynamic> _$MedicalRecordBaseToJson(MedicalRecordBase instance) =>
    <String, dynamic>{
      'record_date': instance.recordDate.toIso8601String(),
      'diagnosis': instance.diagnosis,
      'treatment': instance.treatment,
    };

MedicalRecordCreate _$MedicalRecordCreateFromJson(Map<String, dynamic> json) =>
    MedicalRecordCreate(
      recordDate: DateTime.parse(json['record_date'] as String),
      diagnosis: json['diagnosis'] as String,
      treatment: json['treatment'] as String,
      patientId: (json['patient_id'] as num).toInt(),
    );

Map<String, dynamic> _$MedicalRecordCreateToJson(
  MedicalRecordCreate instance,
) => <String, dynamic>{
  'record_date': instance.recordDate.toIso8601String(),
  'diagnosis': instance.diagnosis,
  'treatment': instance.treatment,
  'patient_id': instance.patientId,
};

MedicalRecord _$MedicalRecordFromJson(Map<String, dynamic> json) =>
    MedicalRecord(
      recordDate: DateTime.parse(json['record_date'] as String),
      diagnosis: json['diagnosis'] as String,
      treatment: json['treatment'] as String,
      id: (json['id'] as num).toInt(),
      patient: User.fromJson(json['patient'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MedicalRecordToJson(MedicalRecord instance) =>
    <String, dynamic>{
      'record_date': instance.recordDate.toIso8601String(),
      'diagnosis': instance.diagnosis,
      'treatment': instance.treatment,
      'id': instance.id,
      'patient': instance.patient,
    };
