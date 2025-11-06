import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserBase {
  final String email;
  final String? name;
  final String? gender;
  final String? cpf;
  final String? phone;
  final DateTime? birthday;
  final String? cep;
  final String? logradouro;
  final String? numero;
  final String? complemento;
  final String? bairro;
  final String? estado;
  final String? cidade;

  UserBase({
    required this.email,
    this.name,
    this.gender,
    this.cpf,
    this.phone,
    this.birthday,
    this.cep,
    this.logradouro,
    this.numero,
    this.complemento,
    this.bairro,
    this.estado,
    this.cidade,
  });

  factory UserBase.fromJson(Map<String, dynamic> json) =>
      _$UserBaseFromJson(json);
  Map<String, dynamic> toJson() => _$UserBaseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class UserCreate extends UserBase {
  final String password;

  UserCreate({
    required super.email,
    super.name,
    super.gender,
    super.cpf,
    super.phone,
    super.birthday,
    super.cep,
    super.logradouro,
    super.numero,
    super.complemento,
    super.bairro,
    super.estado,
    super.cidade,
    required this.password,
  });

  factory UserCreate.fromJson(Map<String, dynamic> json) =>
      _$UserCreateFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$UserCreateToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class User extends UserBase {
  final int id;
  final bool isActive;
  // TODO: Replace List<dynamic> with actual MedicalRecord and Prescription models when available
  final List<dynamic>? medicalRecords;
  final List<dynamic>? prescriptions;

  User({
    required super.email,
    super.name,
    super.gender,
    super.cpf,
    super.phone,
    super.birthday,
    super.cep,
    super.logradouro,
    super.numero,
    super.complemento,
    super.bairro,
    super.estado,
    super.cidade,
    required this.id,
    required this.isActive,
    this.medicalRecords,
    this.prescriptions,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class UserMeResponse extends UserBase {
  final int id;
  final bool isActive;
  final bool hasActivePayment;

  UserMeResponse({
    required super.email,
    super.name,
    super.gender,
    super.cpf,
    super.phone,
    super.birthday,
    super.cep,
    super.logradouro,
    super.numero,
    super.complemento,
    super.bairro,
    super.estado,
    super.cidade,
    required this.id,
    required this.isActive,
    required this.hasActivePayment,
  });

  factory UserMeResponse.fromJson(Map<String, dynamic> json) =>
      _$UserMeResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$UserMeResponseToJson(this);
}
