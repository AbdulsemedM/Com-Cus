// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_orders_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$UserOrdersState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(String msg) error,
    required TResult Function(List<UserOrder> orders) orders,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? loading,
    TResult? Function(String msg)? error,
    TResult? Function(List<UserOrder> orders)? orders,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(String msg)? error,
    TResult Function(List<UserOrder> orders)? orders,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserOrdersStateInit value) init,
    required TResult Function(UserOrdersStateLoading value) loading,
    required TResult Function(UserOrdersStateError value) error,
    required TResult Function(UserOrdersStateOrders value) orders,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserOrdersStateInit value)? init,
    TResult? Function(UserOrdersStateLoading value)? loading,
    TResult? Function(UserOrdersStateError value)? error,
    TResult? Function(UserOrdersStateOrders value)? orders,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserOrdersStateInit value)? init,
    TResult Function(UserOrdersStateLoading value)? loading,
    TResult Function(UserOrdersStateError value)? error,
    TResult Function(UserOrdersStateOrders value)? orders,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserOrdersStateCopyWith<$Res> {
  factory $UserOrdersStateCopyWith(
          UserOrdersState value, $Res Function(UserOrdersState) then) =
      _$UserOrdersStateCopyWithImpl<$Res, UserOrdersState>;
}

/// @nodoc
class _$UserOrdersStateCopyWithImpl<$Res, $Val extends UserOrdersState>
    implements $UserOrdersStateCopyWith<$Res> {
  _$UserOrdersStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$UserOrdersStateInitImplCopyWith<$Res> {
  factory _$$UserOrdersStateInitImplCopyWith(_$UserOrdersStateInitImpl value,
          $Res Function(_$UserOrdersStateInitImpl) then) =
      __$$UserOrdersStateInitImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UserOrdersStateInitImplCopyWithImpl<$Res>
    extends _$UserOrdersStateCopyWithImpl<$Res, _$UserOrdersStateInitImpl>
    implements _$$UserOrdersStateInitImplCopyWith<$Res> {
  __$$UserOrdersStateInitImplCopyWithImpl(_$UserOrdersStateInitImpl _value,
      $Res Function(_$UserOrdersStateInitImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$UserOrdersStateInitImpl implements UserOrdersStateInit {
  const _$UserOrdersStateInitImpl();

  @override
  String toString() {
    return 'UserOrdersState.init()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserOrdersStateInitImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(String msg) error,
    required TResult Function(List<UserOrder> orders) orders,
  }) {
    return init();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? loading,
    TResult? Function(String msg)? error,
    TResult? Function(List<UserOrder> orders)? orders,
  }) {
    return init?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(String msg)? error,
    TResult Function(List<UserOrder> orders)? orders,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserOrdersStateInit value) init,
    required TResult Function(UserOrdersStateLoading value) loading,
    required TResult Function(UserOrdersStateError value) error,
    required TResult Function(UserOrdersStateOrders value) orders,
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserOrdersStateInit value)? init,
    TResult? Function(UserOrdersStateLoading value)? loading,
    TResult? Function(UserOrdersStateError value)? error,
    TResult? Function(UserOrdersStateOrders value)? orders,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserOrdersStateInit value)? init,
    TResult Function(UserOrdersStateLoading value)? loading,
    TResult Function(UserOrdersStateError value)? error,
    TResult Function(UserOrdersStateOrders value)? orders,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class UserOrdersStateInit implements UserOrdersState {
  const factory UserOrdersStateInit() = _$UserOrdersStateInitImpl;
}

/// @nodoc
abstract class _$$UserOrdersStateLoadingImplCopyWith<$Res> {
  factory _$$UserOrdersStateLoadingImplCopyWith(
          _$UserOrdersStateLoadingImpl value,
          $Res Function(_$UserOrdersStateLoadingImpl) then) =
      __$$UserOrdersStateLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UserOrdersStateLoadingImplCopyWithImpl<$Res>
    extends _$UserOrdersStateCopyWithImpl<$Res, _$UserOrdersStateLoadingImpl>
    implements _$$UserOrdersStateLoadingImplCopyWith<$Res> {
  __$$UserOrdersStateLoadingImplCopyWithImpl(
      _$UserOrdersStateLoadingImpl _value,
      $Res Function(_$UserOrdersStateLoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$UserOrdersStateLoadingImpl implements UserOrdersStateLoading {
  const _$UserOrdersStateLoadingImpl();

  @override
  String toString() {
    return 'UserOrdersState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserOrdersStateLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(String msg) error,
    required TResult Function(List<UserOrder> orders) orders,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? loading,
    TResult? Function(String msg)? error,
    TResult? Function(List<UserOrder> orders)? orders,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(String msg)? error,
    TResult Function(List<UserOrder> orders)? orders,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserOrdersStateInit value) init,
    required TResult Function(UserOrdersStateLoading value) loading,
    required TResult Function(UserOrdersStateError value) error,
    required TResult Function(UserOrdersStateOrders value) orders,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserOrdersStateInit value)? init,
    TResult? Function(UserOrdersStateLoading value)? loading,
    TResult? Function(UserOrdersStateError value)? error,
    TResult? Function(UserOrdersStateOrders value)? orders,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserOrdersStateInit value)? init,
    TResult Function(UserOrdersStateLoading value)? loading,
    TResult Function(UserOrdersStateError value)? error,
    TResult Function(UserOrdersStateOrders value)? orders,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class UserOrdersStateLoading implements UserOrdersState {
  const factory UserOrdersStateLoading() = _$UserOrdersStateLoadingImpl;
}

/// @nodoc
abstract class _$$UserOrdersStateErrorImplCopyWith<$Res> {
  factory _$$UserOrdersStateErrorImplCopyWith(_$UserOrdersStateErrorImpl value,
          $Res Function(_$UserOrdersStateErrorImpl) then) =
      __$$UserOrdersStateErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String msg});
}

/// @nodoc
class __$$UserOrdersStateErrorImplCopyWithImpl<$Res>
    extends _$UserOrdersStateCopyWithImpl<$Res, _$UserOrdersStateErrorImpl>
    implements _$$UserOrdersStateErrorImplCopyWith<$Res> {
  __$$UserOrdersStateErrorImplCopyWithImpl(_$UserOrdersStateErrorImpl _value,
      $Res Function(_$UserOrdersStateErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? msg = null,
  }) {
    return _then(_$UserOrdersStateErrorImpl(
      null == msg
          ? _value.msg
          : msg // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$UserOrdersStateErrorImpl implements UserOrdersStateError {
  const _$UserOrdersStateErrorImpl(this.msg);

  @override
  final String msg;

  @override
  String toString() {
    return 'UserOrdersState.error(msg: $msg)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserOrdersStateErrorImpl &&
            (identical(other.msg, msg) || other.msg == msg));
  }

  @override
  int get hashCode => Object.hash(runtimeType, msg);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserOrdersStateErrorImplCopyWith<_$UserOrdersStateErrorImpl>
      get copyWith =>
          __$$UserOrdersStateErrorImplCopyWithImpl<_$UserOrdersStateErrorImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(String msg) error,
    required TResult Function(List<UserOrder> orders) orders,
  }) {
    return error(msg);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? loading,
    TResult? Function(String msg)? error,
    TResult? Function(List<UserOrder> orders)? orders,
  }) {
    return error?.call(msg);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(String msg)? error,
    TResult Function(List<UserOrder> orders)? orders,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(msg);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserOrdersStateInit value) init,
    required TResult Function(UserOrdersStateLoading value) loading,
    required TResult Function(UserOrdersStateError value) error,
    required TResult Function(UserOrdersStateOrders value) orders,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserOrdersStateInit value)? init,
    TResult? Function(UserOrdersStateLoading value)? loading,
    TResult? Function(UserOrdersStateError value)? error,
    TResult? Function(UserOrdersStateOrders value)? orders,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserOrdersStateInit value)? init,
    TResult Function(UserOrdersStateLoading value)? loading,
    TResult Function(UserOrdersStateError value)? error,
    TResult Function(UserOrdersStateOrders value)? orders,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class UserOrdersStateError implements UserOrdersState {
  const factory UserOrdersStateError(final String msg) =
      _$UserOrdersStateErrorImpl;

  String get msg;
  @JsonKey(ignore: true)
  _$$UserOrdersStateErrorImplCopyWith<_$UserOrdersStateErrorImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UserOrdersStateOrdersImplCopyWith<$Res> {
  factory _$$UserOrdersStateOrdersImplCopyWith(
          _$UserOrdersStateOrdersImpl value,
          $Res Function(_$UserOrdersStateOrdersImpl) then) =
      __$$UserOrdersStateOrdersImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<UserOrder> orders});
}

/// @nodoc
class __$$UserOrdersStateOrdersImplCopyWithImpl<$Res>
    extends _$UserOrdersStateCopyWithImpl<$Res, _$UserOrdersStateOrdersImpl>
    implements _$$UserOrdersStateOrdersImplCopyWith<$Res> {
  __$$UserOrdersStateOrdersImplCopyWithImpl(_$UserOrdersStateOrdersImpl _value,
      $Res Function(_$UserOrdersStateOrdersImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orders = null,
  }) {
    return _then(_$UserOrdersStateOrdersImpl(
      null == orders
          ? _value._orders
          : orders // ignore: cast_nullable_to_non_nullable
              as List<UserOrder>,
    ));
  }
}

/// @nodoc

class _$UserOrdersStateOrdersImpl implements UserOrdersStateOrders {
  const _$UserOrdersStateOrdersImpl(final List<UserOrder> orders)
      : _orders = orders;

  final List<UserOrder> _orders;
  @override
  List<UserOrder> get orders {
    if (_orders is EqualUnmodifiableListView) return _orders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orders);
  }

  @override
  String toString() {
    return 'UserOrdersState.orders(orders: $orders)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserOrdersStateOrdersImpl &&
            const DeepCollectionEquality().equals(other._orders, _orders));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_orders));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserOrdersStateOrdersImplCopyWith<_$UserOrdersStateOrdersImpl>
      get copyWith => __$$UserOrdersStateOrdersImplCopyWithImpl<
          _$UserOrdersStateOrdersImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(String msg) error,
    required TResult Function(List<UserOrder> orders) orders,
  }) {
    return orders(this.orders);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? loading,
    TResult? Function(String msg)? error,
    TResult? Function(List<UserOrder> orders)? orders,
  }) {
    return orders?.call(this.orders);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(String msg)? error,
    TResult Function(List<UserOrder> orders)? orders,
    required TResult orElse(),
  }) {
    if (orders != null) {
      return orders(this.orders);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserOrdersStateInit value) init,
    required TResult Function(UserOrdersStateLoading value) loading,
    required TResult Function(UserOrdersStateError value) error,
    required TResult Function(UserOrdersStateOrders value) orders,
  }) {
    return orders(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserOrdersStateInit value)? init,
    TResult? Function(UserOrdersStateLoading value)? loading,
    TResult? Function(UserOrdersStateError value)? error,
    TResult? Function(UserOrdersStateOrders value)? orders,
  }) {
    return orders?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserOrdersStateInit value)? init,
    TResult Function(UserOrdersStateLoading value)? loading,
    TResult Function(UserOrdersStateError value)? error,
    TResult Function(UserOrdersStateOrders value)? orders,
    required TResult orElse(),
  }) {
    if (orders != null) {
      return orders(this);
    }
    return orElse();
  }
}

abstract class UserOrdersStateOrders implements UserOrdersState {
  const factory UserOrdersStateOrders(final List<UserOrder> orders) =
      _$UserOrdersStateOrdersImpl;

  List<UserOrder> get orders;
  @JsonKey(ignore: true)
  _$$UserOrdersStateOrdersImplCopyWith<_$UserOrdersStateOrdersImpl>
      get copyWith => throw _privateConstructorUsedError;
}
