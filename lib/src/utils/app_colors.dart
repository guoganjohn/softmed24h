import 'package:flutter/material.dart';

@immutable
class MyColors extends ThemeExtension<MyColors> {
  const MyColors({
    required this.primaryGreen,
    required this.primaryBlue,
  });

  final Color? primaryGreen;
  final Color? primaryBlue;

  @override
  MyColors copyWith({Color? primaryGreen, Color? primaryBlue}) {
    return MyColors(
      primaryGreen: primaryGreen ?? this.primaryGreen,
      primaryBlue: primaryBlue ?? this.primaryBlue,
    );
  }

  @override
  MyColors lerp(ThemeExtension<MyColors>? other, double t) {
    if (other is! MyColors) {
      return this;
    }
    return MyColors(
      primaryGreen: Color.lerp(primaryGreen, other.primaryGreen, t),
      primaryBlue: Color.lerp(primaryBlue, other.primaryBlue, t),
    );
  }
}