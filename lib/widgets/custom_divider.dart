import 'package:flutter/material.dart';

import '../constant/theme.dart';

Widget customDivider() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Divider(
      color: TokpedDarkGreen,
      thickness: 1,
    ),
  );
}
