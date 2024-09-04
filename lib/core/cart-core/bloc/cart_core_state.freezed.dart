// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_core_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CartCoreState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function(String errorMessage) error,
    required TResult Function() loading,
    required TResult Function(String success) success,
    required TResult Function(List<CartItem> product) cartItems,
    required TResult Function() loginUser,
    required TResult Function() checkOutUser,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function(String errorMessage)? error,
    TResult? Function()? loading,
    TResult? Function(String success)? success,
    TResult? Function(List<CartItem> product)? cartItems,
    TResult? Function()? loginUser,
    TResult? Function()? checkOutUser,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(String errorMessage)? error,
    TResult Function()? loading,
    TResult Function(String success)? success,
    TResult Function(List<CartItem> product)? cartItems,
    TResult Function()? loginUser,
    TResult Function()? checkOutUser,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CartCoreStateInit value) init,
    required TResult Function(CartCoreStateError value) error,
    required TResult Function(CartCoreStateLoading value) loading,
    required TResult Function(CartCoreStateSuccess value) success,
    required TResult Function(CartCoreStateData value) cartItems,
    required TResult Function(CartCoreStateLoginUser value) loginUser,
    required TResult Function(CartCoreStateCheckOutUser value) checkOutUser,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CartCoreStateInit value)? init,
    TResult? Function(CartCoreStateError value)? error,
    TResult? Function(CartCoreStateLoading value)? loading,
    TResult? Function(CartCoreStateSuccess value)? success,
    TResult? Function(CartCoreStateData value)? cartItems,
    TResult? Function(CartCoreStateLoginUser value)? loginUser,
    TResult? Function(CartCoreStateCheckOutUser value)? checkOutUser,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CartCoreStateInit value)? init,
    TResult Function(CartCoreStateError value)? error,
    TResult Function(CartCoreStateLoading value)? loading,
    TResult Function(CartCoreStateSuccess value)? success,
    TResult Function(CartCoreStateData value)? cartItems,
    TResult Function(CartCoreStateLoginUser value)? loginUser,
    TResult Function(CartCoreStateCheckOutUser value)? checkOutUser,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartCoreStateCopyWith<$Res> {
  factory $CartCoreStateCopyWith(
          CartCoreState value, $Res Function(CartCoreState) then) =
      _$CartCoreStateCopyWithImpl<$Res, CartCoreState>;
}

/// @nodoc
class _$CartCoreStateCopyWithImpl<$Res, $Val extends CartCoreState>
    implements $CartCoreStateCopyWith<$Res> {
  _$CartCoreStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$CartCoreStateInitImplCopyWith<$Res> {
  factory _$$CartCoreStateInitImplCopyWith(_$CartCoreStateInitImpl value,
          $Res Function(_$CartCoreStateInitImpl) then) =
      __$$CartCoreStateInitImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CartCoreStateInitImplCopyWithImpl<$Res>
    extends _$CartCoreStateCopyWithImpl<$Res, _$CartCoreStateInitImpl>
    implements _$$CartCoreStateInitImplCopyWith<$Res> {
  __$$CartCoreStateInitImplCopyWithImpl(_$CartCoreStateInitImpl _value,
      $Res Function(_$CartCoreStateInitImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$CartCoreStateInitImpl implements CartCoreStateInit {
  const _$CartCoreStateInitImpl();

  @override
  String toString() {
    return 'CartCoreState.init()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CartCoreStateInitImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function(String errorMessage) error,
    required TResult Function() loading,
    required TResult Function(String success) success,
    required TResult Function(List<CartItem> product) cartItems,
    required TResult Function() loginUser,
    required TResult Function() checkOutUser,
  }) {
    return init();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function(String errorMessage)? error,
    TResult? Function()? loading,
    TResult? Function(String success)? success,
    TResult? Function(List<CartItem> product)? cartItems,
    TResult? Function()? loginUser,
    TResult? Function()? checkOutUser,
  }) {
    return init?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(String errorMessage)? error,
    TResult Function()? loading,
    TResult Function(String success)? success,
    TResult Function(List<CartItem> product)? cartItems,
    TResult Function()? loginUser,
    TResult Function()? checkOutUser,
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
    required TResult Function(CartCoreStateInit value) init,
    required TResult Function(CartCoreStateError value) error,
    required TResult Function(CartCoreStateLoading value) loading,
    required TResult Function(CartCoreStateSuccess value) success,
    required TResult Function(CartCoreStateData value) cartItems,
    required TResult Function(CartCoreStateLoginUser value) loginUser,
    required TResult Function(CartCoreStateCheckOutUser value) checkOutUser,
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CartCoreStateInit value)? init,
    TResult? Function(CartCoreStateError value)? error,
    TResult? Function(CartCoreStateLoading value)? loading,
    TResult? Function(CartCoreStateSuccess value)? success,
    TResult? Function(CartCoreStateData value)? cartItems,
    TResult? Function(CartCoreStateLoginUser value)? loginUser,
    TResult? Function(CartCoreStateCheckOutUser value)? checkOutUser,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CartCoreStateInit value)? init,
    TResult Function(CartCoreStateError value)? error,
    TResult Function(CartCoreStateLoading value)? loading,
    TResult Function(CartCoreStateSuccess value)? success,
    TResult Function(CartCoreStateData value)? cartItems,
    TResult Function(CartCoreStateLoginUser value)? loginUser,
    TResult Function(CartCoreStateCheckOutUser value)? checkOutUser,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class CartCoreStateInit implements CartCoreState {
  const factory CartCoreStateInit() = _$CartCoreStateInitImpl;
}

/// @nodoc
abstract class _$$CartCoreStateErrorImplCopyWith<$Res> {
  factory _$$CartCoreStateErrorImplCopyWith(_$CartCoreStateErrorImpl value,
          $Res Function(_$CartCoreStateErrorImpl) then) =
      __$$CartCoreStateErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String errorMessage});
}

/// @nodoc
class __$$CartCoreStateErrorImplCopyWithImpl<$Res>
    extends _$CartCoreStateCopyWithImpl<$Res, _$CartCoreStateErrorImpl>
    implements _$$CartCoreStateErrorImplCopyWith<$Res> {
  __$$CartCoreStateErrorImplCopyWithImpl(_$CartCoreStateErrorImpl _value,
      $Res Function(_$CartCoreStateErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? errorMessage = null,
  }) {
    return _then(_$CartCoreStateErrorImpl(
      null == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CartCoreStateErrorImpl implements CartCoreStateError {
  const _$CartCoreStateErrorImpl(this.errorMessage);

  @override
  final String errorMessage;

  @override
  String toString() {
    return 'CartCoreState.error(errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartCoreStateErrorImpl &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CartCoreStateErrorImplCopyWith<_$CartCoreStateErrorImpl> get copyWith =>
      __$$CartCoreStateErrorImplCopyWithImpl<_$CartCoreStateErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function(String errorMessage) error,
    required TResult Function() loading,
    required TResult Function(String success) success,
    required TResult Function(List<CartItem> product) cartItems,
    required TResult Function() loginUser,
    required TResult Function() checkOutUser,
  }) {
    return error(errorMessage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function(String errorMessage)? error,
    TResult? Function()? loading,
    TResult? Function(String success)? success,
    TResult? Function(List<CartItem> product)? cartItems,
    TResult? Function()? loginUser,
    TResult? Function()? checkOutUser,
  }) {
    return error?.call(errorMessage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(String errorMessage)? error,
    TResult Function()? loading,
    TResult Function(String success)? success,
    TResult Function(List<CartItem> product)? cartItems,
    TResult Function()? loginUser,
    TResult Function()? checkOutUser,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(errorMessage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CartCoreStateInit value) init,
    required TResult Function(CartCoreStateError value) error,
    required TResult Function(CartCoreStateLoading value) loading,
    required TResult Function(CartCoreStateSuccess value) success,
    required TResult Function(CartCoreStateData value) cartItems,
    required TResult Function(CartCoreStateLoginUser value) loginUser,
    required TResult Function(CartCoreStateCheckOutUser value) checkOutUser,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CartCoreStateInit value)? init,
    TResult? Function(CartCoreStateError value)? error,
    TResult? Function(CartCoreStateLoading value)? loading,
    TResult? Function(CartCoreStateSuccess value)? success,
    TResult? Function(CartCoreStateData value)? cartItems,
    TResult? Function(CartCoreStateLoginUser value)? loginUser,
    TResult? Function(CartCoreStateCheckOutUser value)? checkOutUser,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CartCoreStateInit value)? init,
    TResult Function(CartCoreStateError value)? error,
    TResult Function(CartCoreStateLoading value)? loading,
    TResult Function(CartCoreStateSuccess value)? success,
    TResult Function(CartCoreStateData value)? cartItems,
    TResult Function(CartCoreStateLoginUser value)? loginUser,
    TResult Function(CartCoreStateCheckOutUser value)? checkOutUser,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class CartCoreStateError implements CartCoreState {
  const factory CartCoreStateError(final String errorMessage) =
      _$CartCoreStateErrorImpl;

  String get errorMessage;
  @JsonKey(ignore: true)
  _$$CartCoreStateErrorImplCopyWith<_$CartCoreStateErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CartCoreStateLoadingImplCopyWith<$Res> {
  factory _$$CartCoreStateLoadingImplCopyWith(_$CartCoreStateLoadingImpl value,
          $Res Function(_$CartCoreStateLoadingImpl) then) =
      __$$CartCoreStateLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CartCoreStateLoadingImplCopyWithImpl<$Res>
    extends _$CartCoreStateCopyWithImpl<$Res, _$CartCoreStateLoadingImpl>
    implements _$$CartCoreStateLoadingImplCopyWith<$Res> {
  __$$CartCoreStateLoadingImplCopyWithImpl(_$CartCoreStateLoadingImpl _value,
      $Res Function(_$CartCoreStateLoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$CartCoreStateLoadingImpl implements CartCoreStateLoading {
  const _$CartCoreStateLoadingImpl();

  @override
  String toString() {
    return 'CartCoreState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartCoreStateLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function(String errorMessage) error,
    required TResult Function() loading,
    required TResult Function(String success) success,
    required TResult Function(List<CartItem> product) cartItems,
    required TResult Function() loginUser,
    required TResult Function() checkOutUser,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function(String errorMessage)? error,
    TResult? Function()? loading,
    TResult? Function(String success)? success,
    TResult? Function(List<CartItem> product)? cartItems,
    TResult? Function()? loginUser,
    TResult? Function()? checkOutUser,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(String errorMessage)? error,
    TResult Function()? loading,
    TResult Function(String success)? success,
    TResult Function(List<CartItem> product)? cartItems,
    TResult Function()? loginUser,
    TResult Function()? checkOutUser,
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
    required TResult Function(CartCoreStateInit value) init,
    required TResult Function(CartCoreStateError value) error,
    required TResult Function(CartCoreStateLoading value) loading,
    required TResult Function(CartCoreStateSuccess value) success,
    required TResult Function(CartCoreStateData value) cartItems,
    required TResult Function(CartCoreStateLoginUser value) loginUser,
    required TResult Function(CartCoreStateCheckOutUser value) checkOutUser,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CartCoreStateInit value)? init,
    TResult? Function(CartCoreStateError value)? error,
    TResult? Function(CartCoreStateLoading value)? loading,
    TResult? Function(CartCoreStateSuccess value)? success,
    TResult? Function(CartCoreStateData value)? cartItems,
    TResult? Function(CartCoreStateLoginUser value)? loginUser,
    TResult? Function(CartCoreStateCheckOutUser value)? checkOutUser,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CartCoreStateInit value)? init,
    TResult Function(CartCoreStateError value)? error,
    TResult Function(CartCoreStateLoading value)? loading,
    TResult Function(CartCoreStateSuccess value)? success,
    TResult Function(CartCoreStateData value)? cartItems,
    TResult Function(CartCoreStateLoginUser value)? loginUser,
    TResult Function(CartCoreStateCheckOutUser value)? checkOutUser,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class CartCoreStateLoading implements CartCoreState {
  const factory CartCoreStateLoading() = _$CartCoreStateLoadingImpl;
}

/// @nodoc
abstract class _$$CartCoreStateSuccessImplCopyWith<$Res> {
  factory _$$CartCoreStateSuccessImplCopyWith(_$CartCoreStateSuccessImpl value,
          $Res Function(_$CartCoreStateSuccessImpl) then) =
      __$$CartCoreStateSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String success});
}

/// @nodoc
class __$$CartCoreStateSuccessImplCopyWithImpl<$Res>
    extends _$CartCoreStateCopyWithImpl<$Res, _$CartCoreStateSuccessImpl>
    implements _$$CartCoreStateSuccessImplCopyWith<$Res> {
  __$$CartCoreStateSuccessImplCopyWithImpl(_$CartCoreStateSuccessImpl _value,
      $Res Function(_$CartCoreStateSuccessImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
  }) {
    return _then(_$CartCoreStateSuccessImpl(
      null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CartCoreStateSuccessImpl implements CartCoreStateSuccess {
  const _$CartCoreStateSuccessImpl(this.success);

  @override
  final String success;

  @override
  String toString() {
    return 'CartCoreState.success(success: $success)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartCoreStateSuccessImpl &&
            (identical(other.success, success) || other.success == success));
  }

  @override
  int get hashCode => Object.hash(runtimeType, success);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CartCoreStateSuccessImplCopyWith<_$CartCoreStateSuccessImpl>
      get copyWith =>
          __$$CartCoreStateSuccessImplCopyWithImpl<_$CartCoreStateSuccessImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function(String errorMessage) error,
    required TResult Function() loading,
    required TResult Function(String success) success,
    required TResult Function(List<CartItem> product) cartItems,
    required TResult Function() loginUser,
    required TResult Function() checkOutUser,
  }) {
    return success(this.success);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function(String errorMessage)? error,
    TResult? Function()? loading,
    TResult? Function(String success)? success,
    TResult? Function(List<CartItem> product)? cartItems,
    TResult? Function()? loginUser,
    TResult? Function()? checkOutUser,
  }) {
    return success?.call(this.success);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(String errorMessage)? error,
    TResult Function()? loading,
    TResult Function(String success)? success,
    TResult Function(List<CartItem> product)? cartItems,
    TResult Function()? loginUser,
    TResult Function()? checkOutUser,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this.success);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CartCoreStateInit value) init,
    required TResult Function(CartCoreStateError value) error,
    required TResult Function(CartCoreStateLoading value) loading,
    required TResult Function(CartCoreStateSuccess value) success,
    required TResult Function(CartCoreStateData value) cartItems,
    required TResult Function(CartCoreStateLoginUser value) loginUser,
    required TResult Function(CartCoreStateCheckOutUser value) checkOutUser,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CartCoreStateInit value)? init,
    TResult? Function(CartCoreStateError value)? error,
    TResult? Function(CartCoreStateLoading value)? loading,
    TResult? Function(CartCoreStateSuccess value)? success,
    TResult? Function(CartCoreStateData value)? cartItems,
    TResult? Function(CartCoreStateLoginUser value)? loginUser,
    TResult? Function(CartCoreStateCheckOutUser value)? checkOutUser,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CartCoreStateInit value)? init,
    TResult Function(CartCoreStateError value)? error,
    TResult Function(CartCoreStateLoading value)? loading,
    TResult Function(CartCoreStateSuccess value)? success,
    TResult Function(CartCoreStateData value)? cartItems,
    TResult Function(CartCoreStateLoginUser value)? loginUser,
    TResult Function(CartCoreStateCheckOutUser value)? checkOutUser,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class CartCoreStateSuccess implements CartCoreState {
  const factory CartCoreStateSuccess(final String success) =
      _$CartCoreStateSuccessImpl;

  String get success;
  @JsonKey(ignore: true)
  _$$CartCoreStateSuccessImplCopyWith<_$CartCoreStateSuccessImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CartCoreStateDataImplCopyWith<$Res> {
  factory _$$CartCoreStateDataImplCopyWith(_$CartCoreStateDataImpl value,
          $Res Function(_$CartCoreStateDataImpl) then) =
      __$$CartCoreStateDataImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<CartItem> product});
}

/// @nodoc
class __$$CartCoreStateDataImplCopyWithImpl<$Res>
    extends _$CartCoreStateCopyWithImpl<$Res, _$CartCoreStateDataImpl>
    implements _$$CartCoreStateDataImplCopyWith<$Res> {
  __$$CartCoreStateDataImplCopyWithImpl(_$CartCoreStateDataImpl _value,
      $Res Function(_$CartCoreStateDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? product = null,
  }) {
    return _then(_$CartCoreStateDataImpl(
      null == product
          ? _value._product
          : product // ignore: cast_nullable_to_non_nullable
              as List<CartItem>,
    ));
  }
}

/// @nodoc

class _$CartCoreStateDataImpl implements CartCoreStateData {
  const _$CartCoreStateDataImpl(final List<CartItem> product)
      : _product = product;

  final List<CartItem> _product;
  @override
  List<CartItem> get product {
    if (_product is EqualUnmodifiableListView) return _product;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_product);
  }

  @override
  String toString() {
    return 'CartCoreState.cartItems(product: $product)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartCoreStateDataImpl &&
            const DeepCollectionEquality().equals(other._product, _product));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_product));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CartCoreStateDataImplCopyWith<_$CartCoreStateDataImpl> get copyWith =>
      __$$CartCoreStateDataImplCopyWithImpl<_$CartCoreStateDataImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function(String errorMessage) error,
    required TResult Function() loading,
    required TResult Function(String success) success,
    required TResult Function(List<CartItem> product) cartItems,
    required TResult Function() loginUser,
    required TResult Function() checkOutUser,
  }) {
    return cartItems(product);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function(String errorMessage)? error,
    TResult? Function()? loading,
    TResult? Function(String success)? success,
    TResult? Function(List<CartItem> product)? cartItems,
    TResult? Function()? loginUser,
    TResult? Function()? checkOutUser,
  }) {
    return cartItems?.call(product);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(String errorMessage)? error,
    TResult Function()? loading,
    TResult Function(String success)? success,
    TResult Function(List<CartItem> product)? cartItems,
    TResult Function()? loginUser,
    TResult Function()? checkOutUser,
    required TResult orElse(),
  }) {
    if (cartItems != null) {
      return cartItems(product);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CartCoreStateInit value) init,
    required TResult Function(CartCoreStateError value) error,
    required TResult Function(CartCoreStateLoading value) loading,
    required TResult Function(CartCoreStateSuccess value) success,
    required TResult Function(CartCoreStateData value) cartItems,
    required TResult Function(CartCoreStateLoginUser value) loginUser,
    required TResult Function(CartCoreStateCheckOutUser value) checkOutUser,
  }) {
    return cartItems(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CartCoreStateInit value)? init,
    TResult? Function(CartCoreStateError value)? error,
    TResult? Function(CartCoreStateLoading value)? loading,
    TResult? Function(CartCoreStateSuccess value)? success,
    TResult? Function(CartCoreStateData value)? cartItems,
    TResult? Function(CartCoreStateLoginUser value)? loginUser,
    TResult? Function(CartCoreStateCheckOutUser value)? checkOutUser,
  }) {
    return cartItems?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CartCoreStateInit value)? init,
    TResult Function(CartCoreStateError value)? error,
    TResult Function(CartCoreStateLoading value)? loading,
    TResult Function(CartCoreStateSuccess value)? success,
    TResult Function(CartCoreStateData value)? cartItems,
    TResult Function(CartCoreStateLoginUser value)? loginUser,
    TResult Function(CartCoreStateCheckOutUser value)? checkOutUser,
    required TResult orElse(),
  }) {
    if (cartItems != null) {
      return cartItems(this);
    }
    return orElse();
  }
}

abstract class CartCoreStateData implements CartCoreState {
  const factory CartCoreStateData(final List<CartItem> product) =
      _$CartCoreStateDataImpl;

  List<CartItem> get product;
  @JsonKey(ignore: true)
  _$$CartCoreStateDataImplCopyWith<_$CartCoreStateDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CartCoreStateLoginUserImplCopyWith<$Res> {
  factory _$$CartCoreStateLoginUserImplCopyWith(
          _$CartCoreStateLoginUserImpl value,
          $Res Function(_$CartCoreStateLoginUserImpl) then) =
      __$$CartCoreStateLoginUserImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CartCoreStateLoginUserImplCopyWithImpl<$Res>
    extends _$CartCoreStateCopyWithImpl<$Res, _$CartCoreStateLoginUserImpl>
    implements _$$CartCoreStateLoginUserImplCopyWith<$Res> {
  __$$CartCoreStateLoginUserImplCopyWithImpl(
      _$CartCoreStateLoginUserImpl _value,
      $Res Function(_$CartCoreStateLoginUserImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$CartCoreStateLoginUserImpl implements CartCoreStateLoginUser {
  const _$CartCoreStateLoginUserImpl();

  @override
  String toString() {
    return 'CartCoreState.loginUser()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartCoreStateLoginUserImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function(String errorMessage) error,
    required TResult Function() loading,
    required TResult Function(String success) success,
    required TResult Function(List<CartItem> product) cartItems,
    required TResult Function() loginUser,
    required TResult Function() checkOutUser,
  }) {
    return loginUser();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function(String errorMessage)? error,
    TResult? Function()? loading,
    TResult? Function(String success)? success,
    TResult? Function(List<CartItem> product)? cartItems,
    TResult? Function()? loginUser,
    TResult? Function()? checkOutUser,
  }) {
    return loginUser?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(String errorMessage)? error,
    TResult Function()? loading,
    TResult Function(String success)? success,
    TResult Function(List<CartItem> product)? cartItems,
    TResult Function()? loginUser,
    TResult Function()? checkOutUser,
    required TResult orElse(),
  }) {
    if (loginUser != null) {
      return loginUser();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CartCoreStateInit value) init,
    required TResult Function(CartCoreStateError value) error,
    required TResult Function(CartCoreStateLoading value) loading,
    required TResult Function(CartCoreStateSuccess value) success,
    required TResult Function(CartCoreStateData value) cartItems,
    required TResult Function(CartCoreStateLoginUser value) loginUser,
    required TResult Function(CartCoreStateCheckOutUser value) checkOutUser,
  }) {
    return loginUser(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CartCoreStateInit value)? init,
    TResult? Function(CartCoreStateError value)? error,
    TResult? Function(CartCoreStateLoading value)? loading,
    TResult? Function(CartCoreStateSuccess value)? success,
    TResult? Function(CartCoreStateData value)? cartItems,
    TResult? Function(CartCoreStateLoginUser value)? loginUser,
    TResult? Function(CartCoreStateCheckOutUser value)? checkOutUser,
  }) {
    return loginUser?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CartCoreStateInit value)? init,
    TResult Function(CartCoreStateError value)? error,
    TResult Function(CartCoreStateLoading value)? loading,
    TResult Function(CartCoreStateSuccess value)? success,
    TResult Function(CartCoreStateData value)? cartItems,
    TResult Function(CartCoreStateLoginUser value)? loginUser,
    TResult Function(CartCoreStateCheckOutUser value)? checkOutUser,
    required TResult orElse(),
  }) {
    if (loginUser != null) {
      return loginUser(this);
    }
    return orElse();
  }
}

abstract class CartCoreStateLoginUser implements CartCoreState {
  const factory CartCoreStateLoginUser() = _$CartCoreStateLoginUserImpl;
}

/// @nodoc
abstract class _$$CartCoreStateCheckOutUserImplCopyWith<$Res> {
  factory _$$CartCoreStateCheckOutUserImplCopyWith(
          _$CartCoreStateCheckOutUserImpl value,
          $Res Function(_$CartCoreStateCheckOutUserImpl) then) =
      __$$CartCoreStateCheckOutUserImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CartCoreStateCheckOutUserImplCopyWithImpl<$Res>
    extends _$CartCoreStateCopyWithImpl<$Res, _$CartCoreStateCheckOutUserImpl>
    implements _$$CartCoreStateCheckOutUserImplCopyWith<$Res> {
  __$$CartCoreStateCheckOutUserImplCopyWithImpl(
      _$CartCoreStateCheckOutUserImpl _value,
      $Res Function(_$CartCoreStateCheckOutUserImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$CartCoreStateCheckOutUserImpl implements CartCoreStateCheckOutUser {
  const _$CartCoreStateCheckOutUserImpl();

  @override
  String toString() {
    return 'CartCoreState.checkOutUser()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartCoreStateCheckOutUserImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function(String errorMessage) error,
    required TResult Function() loading,
    required TResult Function(String success) success,
    required TResult Function(List<CartItem> product) cartItems,
    required TResult Function() loginUser,
    required TResult Function() checkOutUser,
  }) {
    return checkOutUser();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function(String errorMessage)? error,
    TResult? Function()? loading,
    TResult? Function(String success)? success,
    TResult? Function(List<CartItem> product)? cartItems,
    TResult? Function()? loginUser,
    TResult? Function()? checkOutUser,
  }) {
    return checkOutUser?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(String errorMessage)? error,
    TResult Function()? loading,
    TResult Function(String success)? success,
    TResult Function(List<CartItem> product)? cartItems,
    TResult Function()? loginUser,
    TResult Function()? checkOutUser,
    required TResult orElse(),
  }) {
    if (checkOutUser != null) {
      return checkOutUser();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CartCoreStateInit value) init,
    required TResult Function(CartCoreStateError value) error,
    required TResult Function(CartCoreStateLoading value) loading,
    required TResult Function(CartCoreStateSuccess value) success,
    required TResult Function(CartCoreStateData value) cartItems,
    required TResult Function(CartCoreStateLoginUser value) loginUser,
    required TResult Function(CartCoreStateCheckOutUser value) checkOutUser,
  }) {
    return checkOutUser(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CartCoreStateInit value)? init,
    TResult? Function(CartCoreStateError value)? error,
    TResult? Function(CartCoreStateLoading value)? loading,
    TResult? Function(CartCoreStateSuccess value)? success,
    TResult? Function(CartCoreStateData value)? cartItems,
    TResult? Function(CartCoreStateLoginUser value)? loginUser,
    TResult? Function(CartCoreStateCheckOutUser value)? checkOutUser,
  }) {
    return checkOutUser?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CartCoreStateInit value)? init,
    TResult Function(CartCoreStateError value)? error,
    TResult Function(CartCoreStateLoading value)? loading,
    TResult Function(CartCoreStateSuccess value)? success,
    TResult Function(CartCoreStateData value)? cartItems,
    TResult Function(CartCoreStateLoginUser value)? loginUser,
    TResult Function(CartCoreStateCheckOutUser value)? checkOutUser,
    required TResult orElse(),
  }) {
    if (checkOutUser != null) {
      return checkOutUser(this);
    }
    return orElse();
  }
}

abstract class CartCoreStateCheckOutUser implements CartCoreState {
  const factory CartCoreStateCheckOutUser() = _$CartCoreStateCheckOutUserImpl;
}
