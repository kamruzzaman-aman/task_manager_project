
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';

Widget buildImageWidget(String? base64String) {
  if (base64String == null || base64String.isEmpty) {
    return const Icon(Icons.person); // or any other placeholder widget
  }

  if (base64String.startsWith('data:image')) {
    // Remove data URI prefix if present
    base64String =
        base64String.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
  }

  try {
    List<int> bytes = base64Decode(base64String);
    return Image.memory(
      Uint8List.fromList(bytes),
      fit: BoxFit.cover,
    );
  } catch (e) {
    log('Error decoding base64 image: $e');
    return const Icon(Icons.error); // or any other error placeholder widget
  }
}
