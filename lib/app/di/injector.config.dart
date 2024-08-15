// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../core/addresses-core/data/address_repo_impl.dart' as _i847;
import '../../core/addresses-core/domain/address_repo.dart' as _i940;
import '../../core/cart-core/bloc/cart_core_cubit.dart' as _i660;
import '../../core/cart-core/dao/cart_dao.dart' as _i990;
import '../../core/cart-core/repository/cart_repository.dart' as _i536;
import '../../core/cart-core/repository/cart_repository_impl.dart' as _i904;
import '../../core/cities-core/data/city_core_repo_impl.dart' as _i6;
import '../../core/cities-core/domain/city_core_repo.dart' as _i360;
import '../../core/cities-core/presentation/bloc/city_core_cubit.dart' as _i490;
import '../../core/core-phonenumber/phone_number_utils.dart' as _i670;
import '../../core/core-phonenumber/phone_number_utils_impl.dart' as _i546;
import '../../core/core-utils/core_utils.dart' as _i95;
import '../../core/core-utils/core_utils_impl.dart' as _i374;
import '../../core/customer_loan/data/customer_loan_repo_impl.dart' as _i215;
import '../../core/customer_loan/domain/customer_loan_repo.dart' as _i647;
import '../../core/data/prefs_data.dart' as _i25;
import '../../core/data/prefs_data_impl.dart' as _i16;
import '../../core/device-info/device_info.dart' as _i496;
import '../../core/device-info/device_info_impl.dart' as _i958;
import '../../core/session/data/session_repo_impl.dart' as _i405;
import '../../core/session/domain/session_repo.dart' as _i587;
import '../../core/session/presentation/session_bloc.dart' as _i629;
import '../../features/addresses/presentation/bloc/address_cubit.dart' as _i340;
import '../../features/cash_payment/data/cash_payment_repo_impl.dart' as _i550;
import '../../features/cash_payment/domain/cash_payment_repo.dart' as _i881;
import '../../features/cash_payment/presentation/bloc/cash_payment_cubit.dart'
    as _i524;
import '../../features/categories/presentation/bloc/categories_cubit.dart'
    as _i358;
import '../../features/categories/repository/categories_repo.dart' as _i207;
import '../../features/categories/repository/categories_repo_impl.dart'
    as _i1013;
import '../../features/change_password/data/change_password_repo_impl.dart'
    as _i736;
import '../../features/change_password/domain/change_password_repo.dart'
    as _i478;
import '../../features/change_password/presentation/bloc/change_password_cubit.dart'
    as _i329;
import '../../features/check_out/data/repository/check_out_repo_impl.dart'
    as _i1069;
import '../../features/check_out/domain/check_out_repo.dart' as _i790;
import '../../features/check_out/presentation/bloc/check_out_cubit.dart'
    as _i160;
import '../../features/customer_loan/presentation/bloc/customer_loan_cubit.dart'
    as _i969;
import '../../features/dashboard/bloc/dashboard_cubit.dart' as _i156;
import '../../features/home/data/home_repo_impl.dart' as _i443;
import '../../features/home/domain/home_repostory.dart' as _i358;
import '../../features/home/presentation/cubit/home_cubit.dart' as _i9;
import '../../features/login/data/login_repo_impl.dart' as _i704;
import '../../features/login/domain/login_repository.dart' as _i865;
import '../../features/login/presentation/bloc/login_cubit.dart' as _i345;
import '../../features/order_tracking/data/order_tracking_repo_impl.dart'
    as _i615;
import '../../features/order_tracking/domain/order_tracking_repo.dart' as _i991;
import '../../features/order_tracking/presentation/bloc/order_tracking_cubit.dart'
    as _i330;
import '../../features/otp_payments/data/otp_payment_repo_imp.dart' as _i758;
import '../../features/otp_payments/domain/otp_payment_repo.dart' as _i938;
import '../../features/otp_payments/presentation/bloc/otp_payment_cubit.dart'
    as _i924;
import '../../features/payment/data/payment_repo_impl.dart' as _i387;
import '../../features/payment/domain/payment_repo.dart' as _i363;
import '../../features/payment/presentation/bloc/payment_cubit.dart' as _i420;
import '../../features/products/data/products_repository_impl.dart' as _i3;
import '../../features/products/domain/products_repository.dart' as _i352;
import '../../features/products/presentation/cubit/product_cubit.dart' as _i661;
import '../../features/redirected_payment/data/redirected_payment_repo_impl.dart'
    as _i145;
import '../../features/redirected_payment/domain/redirected_payment_repo.dart'
    as _i671;
import '../../features/reset_password/data/reset_pass_repo_impl.dart' as _i919;
import '../../features/reset_password/domain/reset_pass_repo.dart' as _i527;
import '../../features/reset_password/presentation/cubit/reset_pass_cubit.dart'
    as _i982;
import '../../features/sahay_payment/data/sahay_pay_repo_impl.dart' as _i891;
import '../../features/sahay_payment/domain/sahay_pay_repo.dart' as _i978;
import '../../features/sahay_payment/presentation/bloc/sahay_payment_cubit.dart'
    as _i708;
import '../../features/selected_product/data/selected_product_repository_impl.dart'
    as _i579;
import '../../features/selected_product/domain/selected_product_repository.dart'
    as _i559;
import '../../features/selected_product/presentation/bloc/selected_product_cubit.dart'
    as _i1055;
import '../../features/set_password/data/set_password_repo_impl.dart' as _i1039;
import '../../features/set_password/domain/set_password_repo.dart' as _i28;
import '../../features/set_password/presentation/bloc/user_set_password_cubit.dart'
    as _i957;
import '../../features/special_order/data/special_order_repo_impl.dart'
    as _i903;
import '../../features/special_order/domain/special_order_repo.dart' as _i133;
import '../../features/special_order/presentantion/bloc/special_order_cubit.dart'
    as _i772;
import '../../features/splash/bloc/splash_page_cubit.dart' as _i447;
import '../../features/sub_categories/data/sub_category_impl.dart' as _i10;
import '../../features/sub_categories/domain/sub_category_repository.dart'
    as _i213;
import '../../features/sub_categories/presentation/bloc/sub_category_cubit.dart'
    as _i169;
import '../../features/user/data/user_repo_impl.dart' as _i58;
import '../../features/user/domain/user_repo.dart' as _i914;
import '../../features/user/presentation/bloc/user_cubit.dart' as _i434;
import '../../features/user_orders/data/user_orders_repo_impl.dart' as _i712;
import '../../features/user_orders/domain/user_orders_repo.dart' as _i1038;
import '../../features/user_orders/presentation/bloc/user_orders_bloc.dart'
    as _i4;
import '../../features/user_registration/data/user_registration_repo_impl.dart'
    as _i103;
import '../../features/user_registration/domain/user_registration_repo.dart'
    as _i605;
import '../../features/user_registration/presentation/bloc/user_registration_cubit.dart'
    as _i270;
import '../../features/validate_phone_email/data/validate_repo_impl.dart'
    as _i1064;
import '../../features/validate_phone_email/domain/validate_repo.dart' as _i171;
import '../../features/validate_phone_email/presentation/blocs/validate_cubit.dart'
    as _i615;
import '../data/db/database.dart' as _i45;
import '../data/db/database_module.dart' as _i1016;
import '../data/network/api_provider.dart' as _i10;
import '../data/network/dio_client.dart' as _i765;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final databaseNodule = _$DatabaseNodule();
  final dioClient = _$DioClient();
  gh.factory<_i447.SplashPageCubit>(() => _i447.SplashPageCubit());
  await gh.lazySingletonAsync<_i45.AppDatabase>(
    () => databaseNodule.database,
    preResolve: true,
  );
  gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => databaseNodule.createFlutterSecureStorag());
  gh.lazySingleton<_i361.Dio>(() => dioClient.dio);
  gh.factory<_i670.PhoneNumberUtils>(() => _i546.PhoneNumberUtilsImpl());
  gh.singleton<_i10.ApiProvider>(() => _i10.ApiProvider(gh<_i361.Dio>()));
  gh.factory<_i358.HomeRepository>(
      () => _i443.HomeRepositoryImpl(gh<_i10.ApiProvider>()));
  gh.factory<_i496.DeviceInfo>(() => _i958.DeviceInfoImpl());
  gh.factory<_i213.SubCategoryRepository>(
      () => _i10.SubCategoryImpl(gh<_i10.ApiProvider>()));
  gh.factory<_i95.CoreUtils>(() => _i374.CoreUtilsImpl());
  gh.factory<_i25.PrefsData>(
      () => _i16.PrefsDataImpl(gh<_i558.FlutterSecureStorage>()));
  gh.factory<_i990.CartDao>(
      () => databaseNodule.getCartDao(gh<_i45.AppDatabase>()));
  gh.factory<_i605.UserRegistrationRepo>(() => _i103.UserRegistrationRepoImpl(
        gh<_i10.ApiProvider>(),
        gh<_i496.DeviceInfo>(),
        gh<_i25.PrefsData>(),
      ));
  gh.factory<_i360.CityCoreRepo>(
      () => _i6.CityCoreRepoImpl(gh<_i10.ApiProvider>()));
  gh.factory<_i363.PaymentRepo>(
      () => _i387.PaymentRepoImpl(gh<_i10.ApiProvider>()));
  gh.factory<_i991.OrderTrackingRepo>(
      () => _i615.OrderTrackingRepoImpl(gh<_i10.ApiProvider>()));
  gh.factory<_i1038.UserOrderRepo>(
      () => _i712.UserOrderRepoImpl(gh<_i10.ApiProvider>()));
  gh.factory<_i9.HomeCubit>(
      () => _i9.HomeCubit(homeRepository: gh<_i358.HomeRepository>()));
  gh.factory<_i133.SpecialOrderRepo>(
      () => _i903.SpecialOrderRepoImpl(gh<_i10.ApiProvider>()));
  gh.factory<_i169.SubCategoryCubit>(() => _i169.SubCategoryCubit(
      subCategoryRepository: gh<_i213.SubCategoryRepository>()));
  gh.factory<_i865.LoginRepository>(() => _i704.LoginRepositoryImpl(
        gh<_i25.PrefsData>(),
        gh<_i10.ApiProvider>(),
      ));
  gh.factory<_i28.SetPasswordRepo>(() => _i1039.SetPasswordRepoImpl(
        gh<_i10.ApiProvider>(),
        gh<_i496.DeviceInfo>(),
        gh<_i25.PrefsData>(),
      ));
  gh.factory<_i914.UserRepo>(() => _i58.UserRepoImpl(
        gh<_i25.PrefsData>(),
        gh<_i990.CartDao>(),
      ));
  gh.factory<_i171.ValidateRepo>(() => _i1064.ValidateRepoImpl(
        gh<_i10.ApiProvider>(),
        gh<_i25.PrefsData>(),
      ));
  gh.factory<_i536.CartRepository>(
      () => _i904.CartRepositoryImpl(gh<_i990.CartDao>()));
  gh.factory<_i478.ChangePasswordRepo>(() => _i736.ChangePasswordRepoImpl(
        gh<_i10.ApiProvider>(),
        gh<_i25.PrefsData>(),
      ));
  gh.factory<_i587.SessionRepo>(() => _i405.SessionRepoImpl(
        gh<_i10.ApiProvider>(),
        gh<_i25.PrefsData>(),
      ));
  gh.factory<_i490.CityCoreCubit>(
      () => _i490.CityCoreCubit(gh<_i360.CityCoreRepo>()));
  gh.factory<_i629.SessionCubit>(() => _i629.SessionCubit(
        gh<_i587.SessionRepo>(),
        gh<_i496.DeviceInfo>(),
      ));
  gh.factory<_i957.UserSetPasswordCubit>(
      () => _i957.UserSetPasswordCubit(gh<_i28.SetPasswordRepo>()));
  gh.factory<_i790.CheckOutRepo>(() => _i1069.CheckOutRepoImpl(
        gh<_i10.ApiProvider>(),
        gh<_i990.CartDao>(),
        gh<_i25.PrefsData>(),
        gh<_i587.SessionRepo>(),
      ));
  gh.factory<_i940.AddressRepo>(() => _i847.AddressRepoImpl(
        gh<_i10.ApiProvider>(),
        gh<_i25.PrefsData>(),
      ));
  gh.factory<_i527.ResetPassRepo>(() => _i919.ResetPassRepoImpl(
        gh<_i10.ApiProvider>(),
        gh<_i25.PrefsData>(),
      ));
  gh.factory<_i330.OrderTrackingCubit>(
      () => _i330.OrderTrackingCubit(gh<_i991.OrderTrackingRepo>()));
  gh.factory<_i270.UserRegistrationCubit>(() => _i270.UserRegistrationCubit(
        gh<_i605.UserRegistrationRepo>(),
        gh<_i670.PhoneNumberUtils>(),
      ));
  gh.factory<_i329.ChangePasswordCubit>(
      () => _i329.ChangePasswordCubit(gh<_i478.ChangePasswordRepo>()));
  gh.factory<_i772.SpecialOrderCubit>(
      () => _i772.SpecialOrderCubit(gh<_i133.SpecialOrderRepo>()));
  gh.factory<_i4.UserOrdersBloc>(
      () => _i4.UserOrdersBloc(gh<_i1038.UserOrderRepo>()));
  gh.factory<_i671.RedirectedPaymentRepo>(() => _i145.RedirectedPaymentRepoImp(
        apiProvider: gh<_i10.ApiProvider>(),
        prefsData: gh<_i25.PrefsData>(),
        cartDao: gh<_i990.CartDao>(),
        sessionRepo: gh<_i587.SessionRepo>(),
      ));
  gh.factory<_i978.SahayPayRepo>(() => _i891.SahayPayRepoImpl(
        gh<_i10.ApiProvider>(),
        gh<_i25.PrefsData>(),
        gh<_i990.CartDao>(),
        gh<_i587.SessionRepo>(),
      ));
  gh.factory<_i938.OtpPaymentRepo>(() => _i758.OtpPaymentRepoImp(
        gh<_i10.ApiProvider>(),
        gh<_i25.PrefsData>(),
        gh<_i990.CartDao>(),
        gh<_i587.SessionRepo>(),
      ));
  gh.factory<_i352.ProductRepository>(() => _i3.ProductsRepositoryImpl(
        gh<_i587.SessionRepo>(),
        gh<_i10.ApiProvider>(),
      ));
  gh.factory<_i207.CategoriesRepo>(() => _i1013.CategoriesRepoImpl(
        gh<_i587.SessionRepo>(),
        gh<_i10.ApiProvider>(),
      ));
  gh.factory<_i160.CheckOutCubit>(() => _i160.CheckOutCubit(
        gh<_i790.CheckOutRepo>(),
        gh<_i536.CartRepository>(),
        gh<_i587.SessionRepo>(),
      ));
  gh.factory<_i559.SelectedProductRepo>(
      () => _i579.SelectedProductPageRepositoryImpl(
            gh<_i587.SessionRepo>(),
            gh<_i10.ApiProvider>(),
          ));
  gh.factory<_i358.CategoriesCubit>(
      () => _i358.CategoriesCubit(categoriesRepo: gh<_i207.CategoriesRepo>()));
  gh.factory<_i615.ValidateCubit>(
      () => _i615.ValidateCubit(gh<_i171.ValidateRepo>()));
  gh.factory<_i345.LoginCubit>(() => _i345.LoginCubit(
        gh<_i865.LoginRepository>(),
        gh<_i670.PhoneNumberUtils>(),
      ));
  gh.factory<_i1055.SelectedProductCubit>(
      () => _i1055.SelectedProductCubit(gh<_i559.SelectedProductRepo>()));
  gh.factory<_i881.CashPaymentRepo>(() => _i550.CashPaymentRepoImpl(
        gh<_i10.ApiProvider>(),
        gh<_i25.PrefsData>(),
        gh<_i990.CartDao>(),
        gh<_i587.SessionRepo>(),
      ));
  gh.factory<_i660.CartCoreCubit>(() => _i660.CartCoreCubit(
        gh<_i536.CartRepository>(),
        gh<_i865.LoginRepository>(),
      ));
  gh.factory<_i156.DashboardCubit>(
      () => _i156.DashboardCubit(gh<_i587.SessionRepo>()));
  gh.factory<_i982.ResetPassCubit>(() => _i982.ResetPassCubit(
        gh<_i527.ResetPassRepo>(),
        gh<_i670.PhoneNumberUtils>(),
      ));
  gh.factory<_i647.CustomerLoanRepo>(() => _i215.CustomerLoanRepoImpl(
        gh<_i10.ApiProvider>(),
        gh<_i25.PrefsData>(),
        gh<_i990.CartDao>(),
        gh<_i587.SessionRepo>(),
      ));
  gh.factory<_i420.PaymentCubit>(() => _i420.PaymentCubit(
        gh<_i363.PaymentRepo>(),
        gh<_i647.CustomerLoanRepo>(),
      ));
  gh.factory<_i434.UserCubit>(() => _i434.UserCubit(
        gh<_i914.UserRepo>(),
        gh<_i95.CoreUtils>(),
      ));
  gh.factory<_i524.CashPaymentCubit>(() => _i524.CashPaymentCubit(
        gh<_i881.CashPaymentRepo>(),
        gh<_i670.PhoneNumberUtils>(),
      ));
  gh.factory<_i340.AddressCubit>(
      () => _i340.AddressCubit(gh<_i940.AddressRepo>()));
  gh.factory<_i969.CustomerLoanCubit>(() => _i969.CustomerLoanCubit(
        gh<_i536.CartRepository>(),
        gh<_i647.CustomerLoanRepo>(),
      ));
  gh.factory<_i708.SahayPaymentCubit>(() => _i708.SahayPaymentCubit(
        gh<_i978.SahayPayRepo>(),
        gh<_i670.PhoneNumberUtils>(),
      ));
  gh.factory<_i661.ProductCubit>(() =>
      _i661.ProductCubit(productRepository: gh<_i352.ProductRepository>()));
  gh.factory<_i924.OtpPaymentCubit>(() => _i924.OtpPaymentCubit(
        gh<_i938.OtpPaymentRepo>(),
        gh<_i670.PhoneNumberUtils>(),
      ));
  return getIt;
}

class _$DatabaseNodule extends _i1016.DatabaseNodule {}

class _$DioClient extends _i765.DioClient {}
