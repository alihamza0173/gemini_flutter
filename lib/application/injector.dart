import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Injector extends StatelessWidget {
  const Injector({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(child: child);
  }
}
