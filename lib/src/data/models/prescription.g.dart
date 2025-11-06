// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prescription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrescriptionBase _$PrescriptionBaseFromJson(Map<String, dynamic> json) =>
    PrescriptionBase(
      prescriptionDate: DateTime.parse(json['prescription_date'] as String),
      medication: json['medication'] as String,
      dosage: json['dosage'] as String,
    );

Map<String, dynamic> _$PrescriptionBaseToJson(PrescriptionBase instance) =>
    <String, dynamic>{
      'prescription_date': instance.prescriptionDate.toIso8601String(),
      'medication': instance.medication,
      'dosage': instance.dosage,
    };

PrescriptionCreate _$PrescriptionCreateFromJson(Map<String, dynamic> json) =>
    PrescriptionCreate(
      prescriptionDate: DateTime.parse(json['prescription_date'] as String),
      medication: json['medication'] as String,
      dosage: json['dosage'] as String,
      patientId: (json['patient_id'] as num).toInt(),
      prescriberId: (json['prescriber_id'] as num).toInt(),
    );

Map<String, dynamic> _$PrescriptionCreateToJson(PrescriptionCreate instance) =>
    <String, dynamic>{
      'prescription_date': instance.prescriptionDate.toIso8601String(),
      'medication': instance.medication,
      'dosage': instance.dosage,
      'patient_id': instance.patientId,
      'prescriber_id': instance.prescriberId,
    };

Prescription _$PrescriptionFromJson(Map<String, dynamic> json) => Prescription(
  prescriptionDate: DateTime.parse(json['prescription_date'] as String),
  medication: json['medication'] as String,
  dosage: json['dosage'] as String,
  id: (json['id'] as num).toInt(),
  patient: User.fromJson(json['patient'] as Map<String, dynamic>),
  prescriber: User.fromJson(json['prescriber'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PrescriptionToJson(Prescription instance) =>
    <String, dynamic>{
      'prescription_date': instance.prescriptionDate.toIso8601String(),
      'medication': instance.medication,
      'dosage': instance.dosage,
      'id': instance.id,
      'patient': instance.patient,
      'prescriber': instance.prescriber,
    };

CreatePrescriptionRequest _$CreatePrescriptionRequestFromJson(
  Map<String, dynamic> json,
) => CreatePrescriptionRequest(
  patientName: json['patient_name'] as String,
  medicines: (json['medicines'] as List<dynamic>)
      .map((e) => e as Map<String, dynamic>)
      .toList(),
);

Map<String, dynamic> _$CreatePrescriptionRequestToJson(
  CreatePrescriptionRequest instance,
) => <String, dynamic>{
  'patient_name': instance.patientName,
  'medicines': instance.medicines,
};
