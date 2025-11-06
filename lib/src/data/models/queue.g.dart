// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueueStats _$QueueStatsFromJson(Map<String, dynamic> json) => QueueStats(
  totalPatients: (json['total_patients'] as num).toInt(),
  patientsInQueue: (json['patients_in_queue'] as num).toInt(),
  patientsInService: (json['patients_in_service'] as num).toInt(),
  averageWaitTimeMinutes: (json['average_wait_time_minutes'] as num).toDouble(),
);

Map<String, dynamic> _$QueueStatsToJson(QueueStats instance) =>
    <String, dynamic>{
      'total_patients': instance.totalPatients,
      'patients_in_queue': instance.patientsInQueue,
      'patients_in_service': instance.patientsInService,
      'average_wait_time_minutes': instance.averageWaitTimeMinutes,
    };
