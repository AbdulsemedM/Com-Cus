import 'package:commercepal/core/cart-core/dao/cart_dao.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:commercepal/app/utils/logger.dart';

import 'package:sqflite/sqflite.dart';
import 'package:get_it/get_it.dart';

class StorageClearer {
  static final _secureStorage = FlutterSecureStorage();
  static Future<void> clearAllStorage() async {
    try {
      // First close all database connections
      // await Sqflite.close();

      // Clear cart items before deleting database files
      final cartDao = GetIt.I<CartDao>();
      await cartDao.nuke();

      // Clear other storage
      await _secureStorage.deleteAll();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Clear directories
      final tempDir = await getTemporaryDirectory();
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }

      // final appSupportDir = await getApplicationSupportDirectory();
      // if (appSupportDir.existsSync()) {
      //   await appSupportDir.delete(recursive: true);
      // }

      // Clear database files last
      final databasesPath = await getDatabasesPath();
      final dbDir = Directory(databasesPath);
      if (dbDir.existsSync()) {
        final files = dbDir.listSync();
        for (var file in files) {
          if (file is File && file.path.endsWith('.db')) {
            try {
              await file.delete();
            } catch (e) {
              appLog('Error deleting database file: $e');
            }
          }
        }
      }

      // Recreate necessary directories
      await getTemporaryDirectory();
      await getApplicationSupportDirectory();
    } catch (e) {
      appLog('Error clearing storage: $e');
      rethrow;
    }
  }
}
