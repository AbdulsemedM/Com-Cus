import 'dart:developer';

import 'package:commercepal/core/cart-core/dao/cart_dao.dart';
import 'package:commercepal/core/cart-core/domain/cart_item.dart';
import 'package:commercepal/core/cart-core/repository/cart_repository.dart';
import 'package:commercepal/features/translation/translation_api.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CartRepository)
class CartRepositoryImpl implements CartRepository {
  final CartDao cartDao;

  CartRepositoryImpl(this.cartDao);

  @override
  Future addToCart(CartItem cartItem) async {
    // print("cartIteminaddtocart");
    // print(cartItem.createdAt);
    try {
      final exist =
          await cartDao.getCartItemBySubProductId(cartItem.subProductId!);
      var pros = await cartDao.getAllItems();
      for (var i in pros) {
        print("it exists");
        // print(i.price);
        // print(i.createdAt);
      }
      if (exist == null) {
        await cartDao.insert(cartItem);
        var pros = await cartDao.getAllItems();
        for (var i in pros) {
          // print(i.subProductId);
          print(i.createdAt);
        }
      } else {
        print("it doesn't exists");
        // change item quantity
        exist.quantity = (exist.quantity! + 1);
        await cartDao.insert(exist);
      }
    } catch (e) {
      print("the errir");
      Fimber.e(e.toString());
      rethrow;
    }
  }

  @override
  Stream<List<CartItem>> listenToCartUpdates() => cartDao.listenToItemUpdates();

  @override
  Future deleteItem(CartItem cartItem) async {
    try {
      var pros = await cartDao.getAllItems();
      for (var i in pros) {
        if (i.productId == cartItem.productId) {
          await cartDao.deleteItem(i.subProductId!);
        }
      }
      await cartDao.deleteItem(cartItem.subProductId!);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CartItem>> getCartItems() async {
    // Await the translation result
    final message = await TranslationService.translate('No items found');

    try {
      final items = await cartDao.getAllItems();
      if (items.isEmpty) {
        throw message;
      } else {
        // cartDao.nuke();
        return items;
      }
    } on TypeError catch (e) {
      await cartDao.nuke();
      throw Exception('Data format issue: ${e.toString()}');
    } catch (e) {
      // Handle other general errors
      await cartDao.nuke();
      rethrow;
    }
  }

  // void clearCart() async {
  //   try {
  //     await cartDao.nuke();
  //     print('All cart items deleted successfully');
  //   } catch (e) {
  //     print('Failed to clear cart: $e');
  //   }
  // }

  @override
  Future updateItemInCart(CartItem cartItem) async {
    await cartDao.insert(cartItem);
  }
}
