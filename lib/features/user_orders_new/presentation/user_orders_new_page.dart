import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/features/user_orders_new/cubit/user_orders_cubit.dart';
import 'package:commercepal/features/user_orders_new/cubit/user_orders_state.dart';
import 'package:commercepal/features/user_orders_new/models/user_order_model.dart';
import 'package:commercepal/features/user_orders_new/repository/user_orders_repository.dart';
import 'package:commercepal/features/orders/presentation/order_screen.dart';

class UserOrdersNewPage extends StatefulWidget {
  static const routeName = "/user_orders_new";

  const UserOrdersNewPage({super.key});

  @override
  State<UserOrdersNewPage> createState() => _UserOrdersNewPageState();
}

class _UserOrdersNewPageState extends State<UserOrdersNewPage> {
  final ScrollController _scrollController = ScrollController();
  late UserOrdersCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = UserOrdersCubit(UserOrdersRepository());
    _cubit.fetchOrders();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _cubit.loadMoreOrders();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'My Orders',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.colorPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocProvider(
        create: (context) => _cubit,
        child: BlocBuilder<UserOrdersCubit, UserOrdersState>(
          builder: (context, state) {
            if (state is UserOrdersLoading) {
              return _buildLoadingState();
            } else if (state is UserOrdersLoaded) {
              return _buildLoadedState(state);
            } else if (state is UserOrdersLoadingMore) {
              return _buildLoadingMoreState(state);
            } else if (state is UserOrdersError) {
              return _buildErrorState(state);
            } else if (state is UserOrdersNotLoggedIn) {
              return _buildNotLoggedInState();
            }
            return _buildLoadingState();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: [
        _buildShimmerHeader(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 6, // Show 6 shimmer cards
            itemBuilder: (context, index) => _buildShimmerCard(),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadedState(UserOrdersLoaded state) {
    if (state.orders.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        _buildHeader(state.pagination),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: state.orders.length + (state.hasReachedMax ? 0 : 1),
            itemBuilder: (context, index) {
              if (index >= state.orders.length) {
                return _buildLoadingIndicator();
              }
              return _buildOrderCard(state.orders[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingMoreState(UserOrdersLoadingMore state) {
    return Column(
      children: [
        _buildHeader(state.pagination),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: state.currentOrders.length + 1,
            itemBuilder: (context, index) {
              if (index >= state.currentOrders.length) {
                return _buildLoadingIndicator();
              }
              return _buildOrderCard(state.currentOrders[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(UserOrdersPagination pagination) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Total Orders: ${pagination.totalElements}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Text(
            'Page ${pagination.currentPage + 1} of ${pagination.totalPages}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(UserOrderModel order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToOrderDetails(order.orderRef),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: order.images.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          order.images.first,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.shopping_bag,
                              color: Colors.grey[400],
                              size: 30,
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.shopping_bag,
                        color: Colors.grey[400],
                        size: 30,
                      ),
              ),
              const SizedBox(width: 16),
              // Order Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Number
                    Text(
                      order.orderRef,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Payment Method
                    Text(
                      order.paymentMethod,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Total Price
                    Text(
                      order.formatedTotalPrice,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.colorPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              // Status and Action
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Payment Status
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.paymentStatus),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order.paymentStatus,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Current Stage
                  Text(
                    order.currentStage,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Track Order Button
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'track order',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.colorPrimary),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Orders Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You haven\'t placed any orders yet',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(UserOrdersError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Error Loading Orders',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              state.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _cubit.retry(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.colorPrimary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotLoggedInState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Please Log In',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You need to be logged in to view your orders',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _navigateToOrderDetails(String orderRef) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderScreen(orderRef: orderRef),
      ),
    );
  }

  Widget _buildShimmerHeader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 100,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shimmer Image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 16),
              // Shimmer Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Number shimmer
                    Container(
                      width: double.infinity,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Payment Method shimmer
                    Container(
                      width: 120,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Price shimmer
                    Container(
                      width: 100,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
              // Shimmer Status and Action
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Status badge shimmer
                  Container(
                    width: 60,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Stage shimmer
                  Container(
                    width: 80,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Track button shimmer
                  Container(
                    width: 90,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}