// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProductState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function(String errorMessage) error,
    required TResult Function() loading,
    required TResult Function(List<Product> product) products,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function(String errorMessage)? error,
    TResult? Function()? loading,
    TResult? Function(List<Product> product)? products,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(String errorMessage)? error,
    TResult Function()? loading,
    TResult Function(List<Product> product)? products,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ProductStateInit value) init,
    required TResult Function(ProductStateError value) error,
    required TResult Function(ProductStateLoading value) loading,
    required TResult Function(ProductStateData value) products,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProductStateInit value)? init,
    TResult? Function(ProductStateError value)? error,
    TResult? Function(ProductStateLoading value)? loading,
    TResult? Function(ProductStateData value)? products,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProductStateInit value)? init,
    TResult Function(ProductStateError value)? error,
    TResult Function(ProductStateLoading value)? loading,
    TResult Function(ProductStateData value)? products,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductStateCopyWith<$Res> {
  factory $ProductStateCopyWith(
          ProductState value, $Res Function(ProductState) then) =
      _$ProductStateCopyWithImpl<$Res, ProductState>;
}

/// @nodoc
class _$ProductStateCopyWithImpl<$Res, $Val extends ProductState>
    implements $ProductStateCopyWith<$Res> {
  _$ProductStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$ProductStateInitImplCopyWith<$Res> {
  factory _$$ProductStateInitImplCopyWith(_$ProductStateInitImpl value,
          $Res Function(_$ProductStateInitImpl) then) =
      __$$ProductStateInitImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ProductStateInitImplCopyWithImpl<$Res>
    extends _$ProductStateCopyWithImpl<$Res, _$ProductStateInitImpl>
    implements _$$ProductStateInitImplCopyWith<$Res> {
  __$$ProductStateInitImplCopyWithImpl(_$ProductStateInitImpl _value,
      $Res Function(_$ProductStateInitImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ProductStateInitImpl implements ProductStateInit {
  const _$ProductStateInitImpl();

  @override
  String toString() {
    return 'ProductState.init()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ProductStateInitImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function(String errorMessage) error,
    required TResult Function() loading,
    required TResult Function(List<Product> product) products,
  }) {
    return init();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function(String errorMessage)? error,
    TResult? Function()? loading,
    TResult? Function(List<Product> product)? products,
  }) {
    return init?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(String errorMessage)? error,
    TResult Function()? loading,
    TResult Function(List<Product> product)? products,
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
    required TResult Function(ProductStateInit value) init,
    required TResult Function(ProductStateError value) error,
    required TResult Function(ProductStateLoading value) loading,
    required TResult Function(ProductStateData value) products,
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProductStateInit value)? init,
    TResult? Function(ProductStateError value)? error,
    TResult? Function(ProductStateLoading value)? loading,
    TResult? Function(ProductStateData value)? products,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProductStateInit value)? init,
    TResult Function(ProductStateError value)? error,
    TResult Function(ProductStateLoading value)? loading,
    TResult Function(ProductStateData value)? products,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class ProductStateInit implements ProductState {
  const factory ProductStateInit() = _$ProductStateInitImpl;
}

/// @nodoc
abstract class _$$ProductStateErrorImplCopyWith<$Res> {
  factory _$$ProductStateErrorImplCopyWith(_$ProductStateErrorImpl value,
          $Res Function(_$ProductStateErrorImpl) then) =
      __$$ProductStateErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String errorMessage});
}

/// @nodoc
class __$$ProductStateErrorImplCopyWithImpl<$Res>
    extends _$ProductStateCopyWithImpl<$Res, _$ProductStateErrorImpl>
    implements _$$ProductStateErrorImplCopyWith<$Res> {
  __$$ProductStateErrorImplCopyWithImpl(_$ProductStateErrorImpl _value,
      $Res Function(_$ProductStateErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? errorMessage = null,
  }) {
    return _then(_$ProductStateErrorImpl(
      null == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ProductStateErrorImpl implements ProductStateError {
  const _$ProductStateErrorImpl(this.errorMessage);

  @override
  final String errorMessage;

  @override
  String toString() {
    return 'ProductState.error(errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductStateErrorImpl &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductStateErrorImplCopyWith<_$ProductStateErrorImpl> get copyWith =>
      __$$ProductStateErrorImplCopyWithImpl<_$ProductStateErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function(String errorMessage) error,
    required TResult Function() loading,
    required TResult Function(List<Product> product) products,
  }) {
    return error(errorMessage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function(String errorMessage)? error,
    TResult? Function()? loading,
    TResult? Function(List<Product> product)? products,
  }) {
    return error?.call(errorMessage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(String errorMessage)? error,
    TResult Function()? loading,
    TResult Function(List<Product> product)? products,
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
    required TResult Function(ProductStateInit value) init,
    required TResult Function(ProductStateError value) error,
    required TResult Function(ProductStateLoading value) loading,
    required TResult Function(ProductStateData value) products,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProductStateInit value)? init,
    TResult? Function(ProductStateError value)? error,
    TResult? Function(ProductStateLoading value)? loading,
    TResult? Function(ProductStateData value)? products,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProductStateInit value)? init,
    TResult Function(ProductStateError value)? error,
    TResult Function(ProductStateLoading value)? loading,
    TResult Function(ProductStateData value)? products,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ProductStateError implements ProductState {
  const factory ProductStateError(final String errorMessage) =
      _$ProductStateErrorImpl;

  String get errorMessage;
  @JsonKey(ignore: true)
  _$$ProductStateErrorImplCopyWith<_$ProductStateErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ProductStateLoadingImplCopyWith<$Res> {
  factory _$$ProductStateLoadingImplCopyWith(_$ProductStateLoadingImpl value,
          $Res Function(_$ProductStateLoadingImpl) then) =
      __$$ProductStateLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ProductStateLoadingImplCopyWithImpl<$Res>
    extends _$ProductStateCopyWithImpl<$Res, _$ProductStateLoadingImpl>
    implements _$$ProductStateLoadingImplCopyWith<$Res> {
  __$$ProductStateLoadingImplCopyWithImpl(_$ProductStateLoadingImpl _value,
      $Res Function(_$ProductStateLoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ProductStateLoadingImpl implements ProductStateLoading {
  const _$ProductStateLoadingImpl();

  @override
  String toString() {
    return 'ProductState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductStateLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function(String errorMessage) error,
    required TResult Function() loading,
    required TResult Function(List<Product> product) products,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function(String errorMessage)? error,
    TResult? Function()? loading,
    TResult? Function(List<Product> product)? products,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(String errorMessage)? error,
    TResult Function()? loading,
    TResult Function(List<Product> product)? products,
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
    required TResult Function(ProductStateInit value) init,
    required TResult Function(ProductStateError value) error,
    required TResult Function(ProductStateLoading value) loading,
    required TResult Function(ProductStateData value) products,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProductStateInit value)? init,
    TResult? Function(ProductStateError value)? error,
    TResult? Function(ProductStateLoading value)? loading,
    TResult? Function(ProductStateData value)? products,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProductStateInit value)? init,
    TResult Function(ProductStateError value)? error,
    TResult Function(ProductStateLoading value)? loading,
    TResult Function(ProductStateData value)? products,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class ProductStateLoading implements ProductState {
  const factory ProductStateLoading() = _$ProductStateLoadingImpl;
}

/// @nodoc
abstract class _$$ProductStateDataImplCopyWith<$Res> {
  factory _$$ProductStateDataImplCopyWith(_$ProductStateDataImpl value,
          $Res Function(_$ProductStateDataImpl) then) =
      __$$ProductStateDataImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Product> product});
}

/// @nodoc
class __$$ProductStateDataImplCopyWithImpl<$Res>
    extends _$ProductStateCopyWithImpl<$Res, _$ProductStateDataImpl>
    implements _$$ProductStateDataImplCopyWith<$Res> {
  __$$ProductStateDataImplCopyWithImpl(_$ProductStateDataImpl _value,
      $Res Function(_$ProductStateDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? product = null,
  }) {
    return _then(_$ProductStateDataImpl(
      null == product
          ? _value._product
          : product // ignore: cast_nullable_to_non_nullable
              as List<Product>,
    ));
  }
}

/// @nodoc

class _$ProductStateDataImpl implements ProductStateData {
  const _$ProductStateDataImpl(final List<Product> product)
      : _product = product;

  final List<Product> _product;
  @override
  List<Product> get product {
    if (_product is EqualUnmodifiableListView) return _product;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_product);
  }

  @override
  String toString() {
    return 'ProductState.products(product: $product)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductStateDataImpl &&
            const DeepCollectionEquality().equals(other._product, _product));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_product));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductStateDataImplCopyWith<_$ProductStateDataImpl> get copyWith =>
      __$$ProductStateDataImplCopyWithImpl<_$ProductStateDataImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function(String errorMessage) error,
    required TResult Function() loading,
    required TResult Function(List<Product> product) products,
  }) {
    return products(product);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function(String errorMessage)? error,
    TResult? Function()? loading,
    TResult? Function(List<Product> product)? products,
  }) {
    return products?.call(product);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(String errorMessage)? error,
    TResult Function()? loading,
    TResult Function(List<Product> product)? products,
    required TResult orElse(),
  }) {
    if (products != null) {
      return products(product);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ProductStateInit value) init,
    required TResult Function(ProductStateError value) error,
    required TResult Function(ProductStateLoading value) loading,
    required TResult Function(ProductStateData value) products,
  }) {
    return products(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProductStateInit value)? init,
    TResult? Function(ProductStateError value)? error,
    TResult? Function(ProductStateLoading value)? loading,
    TResult? Function(ProductStateData value)? products,
  }) {
    return products?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProductStateInit value)? init,
    TResult Function(ProductStateError value)? error,
    TResult Function(ProductStateLoading value)? loading,
    TResult Function(ProductStateData value)? products,
    required TResult orElse(),
  }) {
    if (products != null) {
      return products(this);
    }
    return orElse();
  }
}

abstract class ProductStateData implements ProductState {
  const factory ProductStateData(final List<Product> product) =
      _$ProductStateDataImpl;

  List<Product> get product;
  @JsonKey(ignore: true)
  _$$ProductStateDataImplCopyWith<_$ProductStateDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
