import 'package:commercepal/app/data/db/database.dart';
import 'package:commercepal/core/cart-core/dao/cart_dao.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import 'migration.dart';

@module
abstract class DatabaseNodule {
  @preResolve
  @lazySingleton
  Future<AppDatabase> get database async => await $FloorAppDatabase
      .databaseBuilder("commercepal")
      .addMigrations([migration1to2, migration2To3]).build();

  @injectable
  CartDao getCartDao(AppDatabase appDatabase) {
    return appDatabase.cartDao;
  }

  @lazySingleton
  FlutterSecureStorage createFlutterSecureStorag() {
    AndroidOptions getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: false, // Use Keystore instead
          resetOnError: true, // Reset on keystore errors
          keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_PKCS1Padding,
          storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
        );

    IOSOptions getIOSOptions() => const IOSOptions(
          accessibility: KeychainAccessibility.first_unlock_this_device,
        );

    return FlutterSecureStorage(
      aOptions: getAndroidOptions(),
      iOptions: getIOSOptions(),
    );
  }
}
