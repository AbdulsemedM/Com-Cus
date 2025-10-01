import 'package:commercepal/features/user_orders_new/models/user_order_model.dart';

abstract class UserOrdersState {
  const UserOrdersState();
}

class UserOrdersInitial extends UserOrdersState {}

class UserOrdersLoading extends UserOrdersState {}

class UserOrdersLoadingMore extends UserOrdersState {
  final List<UserOrderModel> currentOrders;
  final UserOrdersPagination pagination;

  const UserOrdersLoadingMore({
    required this.currentOrders,
    required this.pagination,
  });
}

class UserOrdersLoaded extends UserOrdersState {
  final List<UserOrderModel> orders;
  final UserOrdersPagination pagination;
  final bool hasReachedMax;

  const UserOrdersLoaded({
    required this.orders,
    required this.pagination,
    this.hasReachedMax = false,
  });

  UserOrdersLoaded copyWith({
    List<UserOrderModel>? orders,
    UserOrdersPagination? pagination,
    bool? hasReachedMax,
  }) {
    return UserOrdersLoaded(
      orders: orders ?? this.orders,
      pagination: pagination ?? this.pagination,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class UserOrdersError extends UserOrdersState {
  final String message;

  const UserOrdersError({required this.message});
}

class UserOrdersNotLoggedIn extends UserOrdersState {}