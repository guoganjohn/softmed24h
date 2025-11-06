// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserBase _$UserBaseFromJson(Map<String, dynamic> json) => UserBase(
  email: json['email'] as String,
  name: json['name'] as String?,
  gender: json['gender'] as String?,
  cpf: json['cpf'] as String?,
  phone: json['phone'] as String?,
  birthday: json['birthday'] == null
      ? null
      : DateTime.parse(json['birthday'] as String),
  cep: json['cep'] as String?,
  logradouro: json['logradouro'] as String?,
  numero: json['numero'] as String?,
  complemento: json['complemento'] as String?,
  bairro: json['bairro'] as String?,
  estado: json['estado'] as String?,
  cidade: json['cidade'] as String?,
);

Map<String, dynamic> _$UserBaseToJson(UserBase instance) => <String, dynamic>{
  'email': instance.email,
  'name': instance.name,
  'gender': instance.gender,
  'cpf': instance.cpf,
  'phone': instance.phone,
  'birthday': instance.birthday?.toIso8601String(),
  'cep': instance.cep,
  'logradouro': instance.logradouro,
  'numero': instance.numero,
  'complemento': instance.complemento,
  'bairro': instance.bairro,
  'estado': instance.estado,
  'cidade': instance.cidade,
};

UserCreate _$UserCreateFromJson(Map<String, dynamic> json) => UserCreate(
  email: json['email'] as String,
  name: json['name'] as String?,
  gender: json['gender'] as String?,
  cpf: json['cpf'] as String?,
  phone: json['phone'] as String?,
  birthday: json['birthday'] == null
      ? null
      : DateTime.parse(json['birthday'] as String),
  cep: json['cep'] as String?,
  logradouro: json['logradouro'] as String?,
  numero: json['numero'] as String?,
  complemento: json['complemento'] as String?,
  bairro: json['bairro'] as String?,
  estado: json['estado'] as String?,
  cidade: json['cidade'] as String?,
  password: json['password'] as String,
);

Map<String, dynamic> _$UserCreateToJson(UserCreate instance) =>
    <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'gender': instance.gender,
      'cpf': instance.cpf,
      'phone': instance.phone,
      'birthday': instance.birthday?.toIso8601String(),
      'cep': instance.cep,
      'logradouro': instance.logradouro,
      'numero': instance.numero,
      'complemento': instance.complemento,
      'bairro': instance.bairro,
      'estado': instance.estado,
      'cidade': instance.cidade,
      'password': instance.password,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
  email: json['email'] as String,
  name: json['name'] as String?,
  gender: json['gender'] as String?,
  cpf: json['cpf'] as String?,
  phone: json['phone'] as String?,
  birthday: json['birthday'] == null
      ? null
      : DateTime.parse(json['birthday'] as String),
  cep: json['cep'] as String?,
  logradouro: json['logradouro'] as String?,
  numero: json['numero'] as String?,
  complemento: json['complemento'] as String?,
  bairro: json['bairro'] as String?,
  estado: json['estado'] as String?,
  cidade: json['cidade'] as String?,
  id: (json['id'] as num).toInt(),
  isActive: json['is_active'] as bool,
  medicalRecords: json['medical_records'] as List<dynamic>?,
  prescriptions: json['prescriptions'] as List<dynamic>?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'email': instance.email,
  'name': instance.name,
  'gender': instance.gender,
  'cpf': instance.cpf,
  'phone': instance.phone,
  'birthday': instance.birthday?.toIso8601String(),
  'cep': instance.cep,
  'logradouro': instance.logradouro,
  'numero': instance.numero,
  'complemento': instance.complemento,
  'bairro': instance.bairro,
  'estado': instance.estado,
  'cidade': instance.cidade,
  'id': instance.id,
  'is_active': instance.isActive,
  'medical_records': instance.medicalRecords,
  'prescriptions': instance.prescriptions,
};

UserMeResponse _$UserMeResponseFromJson(Map<String, dynamic> json) =>
    UserMeResponse(
      email: json['email'] as String,
      name: json['name'] as String?,
      gender: json['gender'] as String?,
      cpf: json['cpf'] as String?,
      phone: json['phone'] as String?,
      birthday: json['birthday'] == null
          ? null
          : DateTime.parse(json['birthday'] as String),
      cep: json['cep'] as String?,
      logradouro: json['logradouro'] as String?,
      numero: json['numero'] as String?,
      complemento: json['complemento'] as String?,
      bairro: json['bairro'] as String?,
      estado: json['estado'] as String?,
      cidade: json['cidade'] as String?,
      id: (json['id'] as num).toInt(),
      isActive: json['is_active'] as bool,
      hasActivePayment: json['has_active_payment'] as bool,
    );

Map<String, dynamic> _$UserMeResponseToJson(UserMeResponse instance) =>
    <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'gender': instance.gender,
      'cpf': instance.cpf,
      'phone': instance.phone,
      'birthday': instance.birthday?.toIso8601String(),
      'cep': instance.cep,
      'logradouro': instance.logradouro,
      'numero': instance.numero,
      'complemento': instance.complemento,
      'bairro': instance.bairro,
      'estado': instance.estado,
      'cidade': instance.cidade,
      'id': instance.id,
      'is_active': instance.isActive,
      'has_active_payment': instance.hasActivePayment,
    };
