// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i13;
import 'package:flutter/material.dart' as _i4;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i14;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../core/addresses-core/data/address_repo_impl.dart' as _i55;
import '../../core/addresses-core/domain/address_repo.dart' as _i54;
import '../../core/cart-core/bloc/cart_core_cubit.dart' as _i56;
import '../../core/cart-core/dao/cart_dao.dart' as _i6;
import '../../core/cart-core/repository/cart_repository.dart' as _i7;
import '../../core/cart-core/repository/cart_repository_impl.dart' as _i8;
import '../../core/cities-core/data/city_core_repo_impl.dart' as _i26;
import '../../core/cities-core/domain/city_core_repo.dart' as _i25;
import '../../core/cities-core/presentation/bloc/city_core_cubit.dart' as _i64;
import '../../core/core-phonenumber/phone_number_utils.dart' as _i15;
import '../../core/core-phonenumber/phone_number_utils_impl.dart' as _i16;
import '../../core/core-utils/core_utils.dart' as _i9;
import '../../core/core-utils/core_utils_impl.dart' as _i10;
import '../../core/customer_loan/data/customer_loan_repo_impl.dart' as _i66;
import '../../core/customer_loan/domain/customer_loan_repo.dart' as _i65;
import '../../core/data/prefs_data.dart' as _i17;
import '../../core/data/prefs_data_impl.dart' as _i18;
import '../../core/device-info/device_info.dart' as _i11;
import '../../core/device-info/device_info_impl.dart' as _i12;
import '../../core/session/data/session_repo_impl.dart' as _i38;
import '../../core/session/domain/session_repo.dart' as _i37;
import '../../core/session/presentation/session_bloc.dart' as _i84;
import '../../features/addresses/presentation/add_address_page.dart' as _i3;
import '../../features/addresses/presentation/bloc/address_cubit.dart' as _i89;
import '../../features/cash_payment/data/cash_payment_repo_impl.dart' as _i58;
import '../../features/cash_payment/domain/cash_payment_repo.dart' as _i57;
import '../../features/cash_payment/presentation/bloc/cash_payment_cubit.dart'
    as _i90;
import '../../features/categories/presentation/bloc/categories_cubit.dart'
    as _i91;
import '../../features/categories/repository/categories_repo.dart' as _i59;
import '../../features/categories/repository/categories_repo_impl.dart' as _i60;
import '../../features/change_password/data/change_password_repo_impl.dart'
    as _i24;
import '../../features/change_password/domain/change_password_repo.dart'
    as _i23;
import '../../features/change_password/presentation/bloc/change_password_cubit.dart'
    as _i61;
import '../../features/check_out/data/repository/check_out_repo_impl.dart'
    as _i63;
import '../../features/check_out/domain/check_out_repo.dart' as _i62;
import '../../features/check_out/presentation/bloc/check_out_cubit.dart'
    as _i92;
import '../../features/customer_loan/presentation/bloc/customer_loan_cubit.dart'
    as _i93;
import '../../features/dashboard/bloc/dashboard_cubit.dart' as _i67;
import '../../features/home/data/home_repo_impl.dart' as _i28;
import '../../features/home/domain/home_repostory.dart' as _i27;
import '../../features/home/presentation/cubit/home_cubit.dart' as _i68;
import '../../features/login/data/login_repo_impl.dart' as _i30;
import '../../features/login/domain/login_repository.dart' as _i29;
import '../../features/login/presentation/bloc/login_cubit.dart' as _i69;
import '../../features/order_tracking/data/order_tracking_repo_impl.dart'
    as _i32;
import '../../features/order_tracking/domain/order_tracking_repo.dart' as _i31;
import '../../features/order_tracking/presentation/bloc/order_tracking_cubit.dart'
    as _i70;
import '../../features/otp_payments/data/otp_payment_repo_imp.dart' as _i72;
import '../../features/otp_payments/domain/otp_payment_repo.dart' as _i71;
import '../../features/otp_payments/presentation/bloc/otp_payment_cubit.dart'
    as _i94;
import '../../features/payment/data/payment_repo_impl.dart' as _i34;
import '../../features/payment/domain/payment_repo.dart' as _i33;
import '../../features/payment/presentation/bloc/payment_cubit.dart' as _i73;
import '../../features/products/data/products_repository_impl.dart' as _i75;
import '../../features/products/domain/products_repository.dart' as _i74;
import '../../features/products/presentation/cubit/product_cubit.dart' as _i95;
import '../../features/redirected_payment/data/redirected_payment_repo_impl.dart'
    as _i77;
import '../../features/redirected_payment/domain/redirected_payment_repo.dart'
    as _i76;
import '../../features/reset_password/data/reset_pass_repo_impl.dart' as _i36;
import '../../features/reset_password/domain/reset_pass_repo.dart' as _i35;
import '../../features/reset_password/presentation/cubit/reset_pass_cubit.dart'
    as _i78;
import '../../features/sahay_payment/data/sahay_pay_repo_impl.dart' as _i80;
import '../../features/sahay_payment/domain/sahay_pay_repo.dart' as _i79;
import '../../features/sahay_payment/presentation/bloc/sahay_payment_cubit.dart'
    as _i81;
import '../../features/selected_product/data/selected_product_repository_impl.dart'
    as _i83;
import '../../features/selected_product/domain/selected_product_repository.dart'
    as _i82;
import '../../features/selected_product/presentation/bloc/selected_product_cubit.dart'
    as _i96;
import '../../features/set_password/data/set_password_repo_impl.dart' as _i40;
import '../../features/set_password/domain/set_password_repo.dart' as _i39;
import '../../features/set_password/presentation/bloc/user_set_password_cubit.dart'
    as _i51;
import '../../features/special_order/data/special_order_repo_impl.dart' as _i42;
import '../../features/special_order/domain/special_order_repo.dart' as _i41;
import '../../features/special_order/presentantion/bloc/special_order_cubit.dart'
    as _i85;
import '../../features/splash/bloc/splash_page_cubit.dart' as _i19;
import '../../features/sub_categories/data/sub_category_impl.dart' as _i44;
import '../../features/sub_categories/domain/sub_category_repository.dart'
    as _i43;
import '../../features/sub_categories/presentation/bloc/sub_category_cubit.dart'
    as _i86;
import '../../features/user/data/user_repo_impl.dart' as _i21;
import '../../features/user/domain/user_repo.dart' as _i20;
import '../../features/user/presentation/bloc/user_cubit.dart' as _i45;
import '../../features/user_orders/data/user_orders_repo_impl.dart' as _i47;
import '../../features/user_orders/domain/user_orders_repo.dart' as _i46;
import '../../features/user_orders/presentation/bloc/user_orders_bloc.dart'
    as _i48;
import '../../features/user_registration/data/user_registration_repo_impl.dart'
    as _i50;
import '../../features/user_registration/domain/user_registration_repo.dart'
    as _i49;
import '../../features/user_registration/presentation/bloc/user_registration_cubit.dart'
    as _i87;
import '../../features/validate_phone_email/data/validate_repo_impl.dart'
    as _i53;
import '../../features/validate_phone_email/domain/validate_repo.dart' as _i52;
import '../../features/validate_phone_email/presentation/blocs/validate_cubit.dart'
    as _i88;
import '../data/db/database.dart' as _i5;
import '../data/db/database_module.dart' as _i97;
import '../data/network/api_provider.dart' as _i22;
import '../data/network/dio_client.dart' as _i98;

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// initializes the registration of main-scope dependencies inside of GetIt
Future<_i1.GetIt> $initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final databaseNodule = _$DatabaseNodule();
  final dioClient = _$DioClient();
  gh.factory<_i3.AddAddressPage>(() => _i3.AddAddressPage(key: gh<_i4.Key>()));
  await gh.lazySingletonAsync<_i5.AppDatabase>(
    () => databaseNodule.database,
    preResolve: true,
  );
  gh.factory<_i6.CartDao>(
      () => databaseNodule.getCartDao(gh<_i5.AppDatabase>()));
  gh.factory<_i7.CartRepository>(
      () => _i8.CartRepositoryImpl(gh<_i6.CartDao>()));
  gh.factory<_i9.CoreUtils>(() => _i10.CoreUtilsImpl());
  gh.factory<_i11.DeviceInfo>(() => _i12.DeviceInfoImpl());
  gh.lazySingleton<_i13.Dio>(() => dioClient.dio);
  gh.lazySingleton<_i14.FlutterSecureStorage>(
      () => databaseNodule.createFlutterSecureStorag());
  gh.factory<_i15.PhoneNumberUtils>(() => _i16.PhoneNumberUtilsImpl());
  gh.factory<_i17.PrefsData>(
      () => _i18.PrefsDataImpl(gh<_i14.FlutterSecureStorage>()));
  gh.factory<_i19.SplashPageCubit>(() => _i19.SplashPageCubit());
  gh.factory<_i20.UserRepo>(() => _i21.UserRepoImpl(
        gh<_i17.PrefsData>(),
        gh<_i6.CartDao>(),
      ));
  gh.singleton<_i22.ApiProvider>(_i22.ApiProvider(gh<_i13.Dio>()));
  gh.factory<_i23.ChangePasswordRepo>(() => _i24.ChangePasswordRepoImpl(
        gh<_i22.ApiProvider>(),
        gh<_i17.PrefsData>(),
      ));
  gh.factory<_i25.CityCoreRepo>(
      () => _i26.CityCoreRepoImpl(gh<_i22.ApiProvider>()));
  gh.factory<_i27.HomeRepository>(
      () => _i28.HomeRepositoryImpl(gh<_i22.ApiProvider>()));
  gh.factory<_i29.LoginRepository>(() => _i30.LoginRepositoryImpl(
        gh<_i17.PrefsData>(),
        gh<_i22.ApiProvider>(),
      ));
  gh.factory<_i31.OrderTrackingRepo>(
      () => _i32.OrderTrackingRepoImpl(gh<_i22.ApiProvider>()));
  gh.factory<_i33.PaymentRepo>(
      () => _i34.PaymentRepoImpl(gh<_i22.ApiProvider>()));
  gh.factory<_i35.ResetPassRepo>(() => _i36.ResetPassRepoImpl(
        gh<_i22.ApiProvider>(),
        gh<_i17.PrefsData>(),
      ));
  gh.factory<_i37.SessionRepo>(() => _i38.SessionRepoImpl(
        gh<_i22.ApiProvider>(),
        gh<_i17.PrefsData>(),
      ));
  gh.factory<_i39.SetPasswordRepo>(() => _i40.SetPasswordRepoImpl(
        gh<_i22.ApiProvider>(),
        gh<_i11.DeviceInfo>(),
        gh<_i17.PrefsData>(),
      ));
  gh.factory<_i41.SpecialOrderRepo>(
      () => _i42.SpecialOrderRepoImpl(gh<_i22.ApiProvider>()));
  gh.factory<_i43.SubCategoryRepository>(
      () => _i44.SubCategoryImpl(gh<_i22.ApiProvider>()));
  gh.factory<_i45.UserCubit>(() => _i45.UserCubit(
        gh<_i20.UserRepo>(),
        gh<_i9.CoreUtils>(),
      ));
  gh.factory<_i46.UserOrderRepo>(
      () => _i47.UserOrderRepoImpl(gh<_i22.ApiProvider>()));
  gh.factory<_i48.UserOrdersBloc>(
      () => _i48.UserOrdersBloc(gh<_i46.UserOrderRepo>()));
  gh.factory<_i49.UserRegistrationRepo>(() => _i50.UserRegistrationRepoImpl(
        gh<_i22.ApiProvider>(),
        gh<_i11.DeviceInfo>(),
        gh<_i17.PrefsData>(),
      ));
  gh.factory<_i51.UserSetPasswordCubit>(
      () => _i51.UserSetPasswordCubit(gh<_i39.SetPasswordRepo>()));
  gh.factory<_i52.ValidateRepo>(() => _i53.ValidateRepoImpl(
        gh<_i22.ApiProvider>(),
        gh<_i17.PrefsData>(),
      ));
  gh.factory<_i54.AddressRepo>(() => _i55.AddressRepoImpl(
        gh<_i22.ApiProvider>(),
        gh<_i17.PrefsData>(),
      ));
  gh.factory<_i56.CartCoreCubit>(() => _i56.CartCoreCubit(
        gh<_i7.CartRepository>(),
        gh<_i29.LoginRepository>(),
      ));
  gh.factory<_i57.CashPaymentRepo>(() => _i58.CashPaymentRepoImpl(
        gh<_i22.ApiProvider>(),
        gh<_i17.PrefsData>(),
        gh<_i6.CartDao>(),
        gh<_i37.SessionRepo>(),
      ));
  gh.factory<_i59.CategoriesRepo>(() => _i60.CategoriesRepoImpl(
        gh<_i37.SessionRepo>(),
        gh<_i22.ApiProvider>(),
      ));
  gh.factory<_i61.ChangePasswordCubit>(
      () => _i61.ChangePasswordCubit(gh<_i23.ChangePasswordRepo>()));
  gh.factory<_i62.CheckOutRepo>(() => _i63.CheckOutRepoImpl(
        gh<_i22.ApiProvider>(),
        gh<_i6.CartDao>(),
        gh<_i17.PrefsData>(),
        gh<_i37.SessionRepo>(),
      ));
  gh.factory<_i64.CityCoreCubit>(
      () => _i64.CityCoreCubit(gh<_i25.CityCoreRepo>()));
  gh.factory<_i65.CustomerLoanRepo>(() => _i66.CustomerLoanRepoImpl(
        gh<_i22.ApiProvider>(),
        gh<_i17.PrefsData>(),
        gh<_i6.CartDao>(),
        gh<_i37.SessionRepo>(),
      ));
  gh.factory<_i67.DashboardCubit>(
      () => _i67.DashboardCubit(gh<_i37.SessionRepo>()));
  gh.factory<_i68.HomeCubit>(
      () => _i68.HomeCubit(homeRepository: gh<_i27.HomeRepository>()));
  gh.factory<_i69.LoginCubit>(() => _i69.LoginCubit(
        gh<_i29.LoginRepository>(),
        gh<_i15.PhoneNumberUtils>(),
      ));
  gh.factory<_i70.OrderTrackingCubit>(
      () => _i70.OrderTrackingCubit(gh<_i31.OrderTrackingRepo>()));
  gh.factory<_i71.OtpPaymentRepo>(() => _i72.OtpPaymentRepoImp(
        gh<_i22.ApiProvider>(),
        gh<_i17.PrefsData>(),
        gh<_i6.CartDao>(),
        gh<_i37.SessionRepo>(),
      ));
  gh.factory<_i73.PaymentCubit>(() => _i73.PaymentCubit(
        gh<_i33.PaymentRepo>(),
        gh<_i65.CustomerLoanRepo>(),
      ));
  gh.factory<_i74.ProductRepository>(() => _i75.ProductsRepositoryImpl(
        gh<_i37.SessionRepo>(),
        gh<_i22.ApiProvider>(),
      ));
  gh.factory<_i76.RedirectedPaymentRepo>(() => _i77.RedirectedPaymentRepoImp(
        apiProvider: gh<_i22.ApiProvider>(),
        prefsData: gh<_i17.PrefsData>(),
        cartDao: gh<_i6.CartDao>(),
        sessionRepo: gh<_i37.SessionRepo>(),
      ));
  gh.factory<_i78.ResetPassCubit>(() => _i78.ResetPassCubit(
        gh<_i35.ResetPassRepo>(),
        gh<_i15.PhoneNumberUtils>(),
      ));
  gh.factory<_i79.SahayPayRepo>(() => _i80.SahayPayRepoImpl(
        gh<_i22.ApiProvider>(),
        gh<_i17.PrefsData>(),
        gh<_i6.CartDao>(),
        gh<_i37.SessionRepo>(),
      ));
  gh.factory<_i81.SahayPaymentCubit>(() => _i81.SahayPaymentCubit(
        gh<_i79.SahayPayRepo>(),
        gh<_i15.PhoneNumberUtils>(),
      ));
  gh.factory<_i82.SelectedProductRepo>(
      () => _i83.SelectedProductPageRepositoryImpl(
            gh<_i37.SessionRepo>(),
            gh<_i22.ApiProvider>(),
          ));
  gh.factory<_i84.SessionCubit>(() => _i84.SessionCubit(
        gh<_i37.SessionRepo>(),
        gh<_i11.DeviceInfo>(),
      ));
  gh.factory<_i85.SpecialOrderCubit>(
      () => _i85.SpecialOrderCubit(gh<_i41.SpecialOrderRepo>()));
  gh.factory<_i86.SubCategoryCubit>(() => _i86.SubCategoryCubit(
      subCategoryRepository: gh<_i43.SubCategoryRepository>()));
  gh.factory<_i87.UserRegistrationCubit>(() => _i87.UserRegistrationCubit(
        gh<_i49.UserRegistrationRepo>(),
        gh<_i15.PhoneNumberUtils>(),
      ));
  gh.factory<_i88.ValidateCubit>(
      () => _i88.ValidateCubit(gh<_i52.ValidateRepo>()));
  gh.factory<_i89.AddressCubit>(
      () => _i89.AddressCubit(gh<_i54.AddressRepo>()));
  gh.factory<_i90.CashPaymentCubit>(() => _i90.CashPaymentCubit(
        gh<_i57.CashPaymentRepo>(),
        gh<_i15.PhoneNumberUtils>(),
      ));
  gh.factory<_i91.CategoriesCubit>(
      () => _i91.CategoriesCubit(categoriesRepo: gh<_i59.CategoriesRepo>()));
  gh.factory<_i92.CheckOutCubit>(() => _i92.CheckOutCubit(
        gh<_i62.CheckOutRepo>(),
        gh<_i7.CartRepository>(),
        gh<_i37.SessionRepo>(),
      ));
  gh.factory<_i93.CustomerLoanCubit>(() => _i93.CustomerLoanCubit(
        gh<_i7.CartRepository>(),
        gh<_i65.CustomerLoanRepo>(),
      ));
  gh.factory<_i94.OtpPaymentCubit>(() => _i94.OtpPaymentCubit(
        gh<_i71.OtpPaymentRepo>(),
        gh<_i15.PhoneNumberUtils>(),
      ));
  gh.factory<_i95.ProductCubit>(
      () => _i95.ProductCubit(productRepository: gh<_i74.ProductRepository>()));
  gh.factory<_i96.SelectedProductCubit>(
      () => _i96.SelectedProductCubit(gh<_i82.SelectedProductRepo>()));
  return getIt;
}

class _$DatabaseNodule extends _i97.DatabaseNodule {}

class _$DioClient extends _i98.DioClient {}