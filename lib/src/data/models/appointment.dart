import 'package:json_annotation/json_annotation.dart';
import 'package:softmed24h/src/data/models/user.dart';

part 'appointment.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AppointmentBase {
  final DateTime appointmentTime;
  final String status;

  AppointmentBase({required this.appointmentTime, this.status = "scheduled"});

  factory AppointmentBase.fromJson(Map<String, dynamic> json) =>
      _$AppointmentBaseFromJson(json);
  Map<String, dynamic> toJson() => _$AppointmentBaseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AppointmentCreate extends AppointmentBase {
  final int patientId;
  final int doctorId;

  AppointmentCreate({
    required super.appointmentTime,
    super.status,
    required this.patientId,
    required this.doctorId,
  });

  factory AppointmentCreate.fromJson(Map<String, dynamic> json) =>
      _$AppointmentCreateFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$AppointmentCreateToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Appointment extends AppointmentBase {
  final int id;
  final User patient;
  final User doctor;

  Appointment({
    required super.appointmentTime,
    super.status,
    required this.id,
    required this.patient,
    required this.doctor,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$AppointmentToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CreateMeetingRequest {
  final String summary;
  final DateTime startTime;
  final DateTime endTime;
  final List<String> attendees;

  CreateMeetingRequest({
    required this.summary,
    required this.startTime,
    required this.endTime,
    this.attendees = const [],
  });

  factory CreateMeetingRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateMeetingRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateMeetingRequestToJson(this);
}
