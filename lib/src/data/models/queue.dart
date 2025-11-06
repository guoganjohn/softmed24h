import 'package:json_annotation/json_annotation.dart';

part 'queue.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class QueueStats {
  final int totalPatients;
  final int patientsInQueue;
  final int patientsInService;
  final double averageWaitTimeMinutes;

  QueueStats({
    required this.totalPatients,
    required this.patientsInQueue,
    required this.patientsInService,
    required this.averageWaitTimeMinutes,
  });

  factory QueueStats.fromJson(Map<String, dynamic> json) =>
      _$QueueStatsFromJson(json);
  Map<String, dynamic> toJson() => _$QueueStatsToJson(this);
}
