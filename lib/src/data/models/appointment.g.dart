// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentBase _$AppointmentBaseFromJson(Map<String, dynamic> json) =>
    AppointmentBase(
      appointmentTime: DateTime.parse(json['appointment_time'] as String),
      status: json['status'] as String? ?? "scheduled",
    );

Map<String, dynamic> _$AppointmentBaseToJson(AppointmentBase instance) =>
    <String, dynamic>{
      'appointment_time': instance.appointmentTime.toIso8601String(),
      'status': instance.status,
    };

AppointmentCreate _$AppointmentCreateFromJson(Map<String, dynamic> json) =>
    AppointmentCreate(
      appointmentTime: DateTime.parse(json['appointment_time'] as String),
      status: json['status'] as String? ?? "scheduled",
      patientId: (json['patient_id'] as num).toInt(),
      doctorId: (json['doctor_id'] as num).toInt(),
    );

Map<String, dynamic> _$AppointmentCreateToJson(AppointmentCreate instance) =>
    <String, dynamic>{
      'appointment_time': instance.appointmentTime.toIso8601String(),
      'status': instance.status,
      'patient_id': instance.patientId,
      'doctor_id': instance.doctorId,
    };

Appointment _$AppointmentFromJson(Map<String, dynamic> json) => Appointment(
  appointmentTime: DateTime.parse(json['appointment_time'] as String),
  status: json['status'] as String? ?? "scheduled",
  id: (json['id'] as num).toInt(),
  patient: User.fromJson(json['patient'] as Map<String, dynamic>),
  doctor: User.fromJson(json['doctor'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AppointmentToJson(Appointment instance) =>
    <String, dynamic>{
      'appointment_time': instance.appointmentTime.toIso8601String(),
      'status': instance.status,
      'id': instance.id,
      'patient': instance.patient,
      'doctor': instance.doctor,
    };

CreateMeetingRequest _$CreateMeetingRequestFromJson(
  Map<String, dynamic> json,
) => CreateMeetingRequest(
  summary: json['summary'] as String,
  startTime: DateTime.parse(json['start_time'] as String),
  endTime: DateTime.parse(json['end_time'] as String),
  attendees:
      (json['attendees'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$CreateMeetingRequestToJson(
  CreateMeetingRequest instance,
) => <String, dynamic>{
  'summary': instance.summary,
  'start_time': instance.startTime.toIso8601String(),
  'end_time': instance.endTime.toIso8601String(),
  'attendees': instance.attendees,
};
