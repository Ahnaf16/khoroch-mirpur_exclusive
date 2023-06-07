import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'widgets.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.error,
    required this.stackTrace,
  });
  final Object error;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (kDebugMode)
          IconButton(
            icon: const Icon(
              Icons.bug_report_outlined,
              size: 25,
              color: Colors.red,
            ),
            onPressed: () => logError(),
          ),
        if (kDebugMode) Text('$error') else const Text('E R R O R')
      ],
    );
  }

  void logError() => log(
        '${'=====' * 10}\n > message: $error ${stackTrace != null ? '\n${'-----' * 10}\n > stack Trace: $stackTrace\n' : '\n'}${'=====' * 10}',
      );

  static Widget errorMathod(error, stackTrace) =>
      ErrorView(error: error, stackTrace: stackTrace);
}

class Loader extends StatelessWidget {
  const Loader({
    super.key,
    this.isList = false,
    this.height,
    this.width,
  });

  final bool isList;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isList)
          Column(
            children: [
              ...List.generate(
                5,
                (index) => KShimmer.card(
                  height: height ?? 50,
                  width: width ?? double.maxFinite,
                ),
              )
            ],
          )
        else
          KShimmer.card(
            height: height ?? 150,
            width: width ?? double.maxFinite,
          ),
      ],
    );
  }

  static Widget loading([bool isList = false]) => Loader(isList: isList);
}
