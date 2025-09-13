import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firenote/firenote.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// [ServiceUtils]
///
/// A [utility] class that provides common [services] used across the app:
/// - [keyboardClosed] → closes the on-screen [keyboard].
/// - [logs] → prints [log] messages (disabled in [kReleaseMode]).
/// - [checkInternetConnection] → checks the device’s [connectivity] and optionally
///   shows a [toast] when no [internet] is available.
///
/// Example:
/// ```dart
/// if (await ServiceUtils.checkInternetConnection(context)) {
///   // Proceed with network request
/// }
/// ```
class ServiceUtils {
  // Closes the keyboard if it's open.
  static void keyboardClosed() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // Logs a message.
  static void logs(String message) => kReleaseMode ? {} : log(message);

  static Future<bool> checkInternetConnection(
    BuildContext context, {
    bool showToast = true,
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none)) {
      if (showToast) {
        Fluttertoast.showToast(
          msg: AppConsts.noInternetConnection,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          fontSize: 14.sp,
        );
      }
      return false;
    }
    return true;
  }
}
