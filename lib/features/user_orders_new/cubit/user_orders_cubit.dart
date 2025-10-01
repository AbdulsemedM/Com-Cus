import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:commercepal/features/user_orders_new/cubit/user_orders_state.dart';
import 'package:commercepal/features/user_orders_new/models/user_order_model.dart';
import 'package:commercepal/features/user_orders_new/repository/user_orders_repository.dart';

class UserOrdersCubit extends Cubit<UserOrdersState> {
  final UserOrdersRepository _repository;
  
  UserOrdersCubit(this._repository) : super(UserOrdersInitial());

  Future<void> fetchOrders({bool refresh = false}) async {
    try {
      // Check if user is logged in
      final isLoggedIn = await _repository.isUserLoggedIn();
      if (!isLoggedIn) {
        emit(UserOrdersNotLoggedIn());
        return;
      }

      if (refresh || state is UserOrdersInitial) {
        emit(UserOrdersLoading());
      }

      final response = await _repository.fetchOrders(page: 0);
      
      emit(UserOrdersLoaded(
        orders: response.orders,
        pagination: response.pagination,
        hasReachedMax: response.pagination.currentPage >= response.pagination.totalPages - 1,
      ));
    } catch (e) {
      emit(UserOrdersError(message: e.toString()));
    }
  }

  Future<void> loadMoreOrders() async {
    final currentState = state;
    if (currentState is! UserOrdersLoaded || currentState.hasReachedMax) {
      return;
    }

    try {
      emit(UserOrdersLoadingMore(
        currentOrders: currentState.orders,
        pagination: currentState.pagination,
      ));

      final nextPage = currentState.pagination.currentPage + 1;
      final response = await _repository.fetchOrders(page: nextPage);
      
      final allOrders = List<UserOrderModel>.from(currentState.orders)
        ..addAll(response.orders);

      emit(UserOrdersLoaded(
        orders: allOrders,
        pagination: response.pagination,
        hasReachedMax: response.pagination.currentPage >= response.pagination.totalPages - 1,
      ));
    } catch (e) {
      emit(UserOrdersError(message: e.toString()));
    }
  }

  void retry() {
    fetchOrders(refresh: true);
  }
}