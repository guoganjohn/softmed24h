import 'package:json_annotation/json_annotation.dart';

part 'report.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ReportResponse {
  final String message;

  ReportResponse({required this.message});

  factory ReportResponse.fromJson(Map<String, dynamic> json) =>
      _$ReportResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ReportResponseToJson(this);
}
