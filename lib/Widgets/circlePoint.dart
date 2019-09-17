
import 'package:flutter/material.dart';

import '../theme.dart';

CirclePoint(){
  return Container(
    width: 18,
    height: 18,
    decoration: BoxDecoration(
      color: mainColor,
      shape: BoxShape.circle,
    ),
  );
}