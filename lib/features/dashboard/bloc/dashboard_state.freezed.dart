// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DashboardState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(bool isBusiness) isUserABusiness,
    required TResult Function(String message) success,
    required TResult Function(bool switched) userSwitchedToBusiness,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? loading,
    TResult? Function(bool isBusiness)? isUserABusiness,
    TResult? Function(String message)? success,
    TResult? Function(bool switched)? userSwitchedToBusiness,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(bool isBusiness)? isUserABusiness,
    TResult Function(String message)? success,
    TResult Function(bool switched)? userSwitchedToBusiness,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DashboardInitState value) init,
    required TResult Function(DashboardLoadingState value) loading,
    required TResult Function(DashboardBusinessState value) isUserABusiness,
    required TResult Function(DashboardSuccessState value) success,
    required TResult Function(DashboardUserSwicthedState value)
        userSwitchedToBusiness,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DashboardInitState value)? init,
    TResult? Function(DashboardLoadingState value)? loading,
    TResult? Function(DashboardBusinessState value)? isUserABusiness,
    TResult? Function(DashboardSuccessState value)? success,
    TResult? Function(DashboardUserSwicthedState value)? userSwitchedToBusiness,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DashboardInitState value)? init,
    TResult Function(DashboardLoadingState value)? loading,
    TResult Function(DashboardBusinessState value)? isUserABusiness,
    TResult Function(DashboardSuccessState value)? success,
    TResult Function(DashboardUserSwicthedState value)? userSwitchedToBusiness,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardStateCopyWith<$Res> {
  factory $DashboardStateCopyWith(
          DashboardState value, $Res Function(DashboardState) then) =
      _$DashboardStateCopyWithImpl<$Res, DashboardState>;
}

/// @nodoc
class _$DashboardStateCopyWithImpl<$Res, $Val extends DashboardState>
    implements $DashboardStateCopyWith<$Res> {
  _$DashboardStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$DashboardInitStateImplCopyWith<$Res> {
  factory _$$DashboardInitStateImplCopyWith(_$DashboardInitStateImpl value,
          $Res Function(_$DashboardInitStateImpl) then) =
      __$$DashboardInitStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DashboardInitStateImplCopyWithImpl<$Res>
    extends _$DashboardStateCopyWithImpl<$Res, _$DashboardInitStateImpl>
    implements _$$DashboardInitStateImplCopyWith<$Res> {
  __$$DashboardInitStateImplCopyWithImpl(_$DashboardInitStateImpl _value,
      $Res Function(_$DashboardInitStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$DashboardInitStateImpl implements DashboardInitState {
  const _$DashboardInitStateImpl();

  @override
  String toString() {
    return 'DashboardState.init()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DashboardInitStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(bool isBusiness) isUserABusiness,
    required TResult Function(String message) success,
    required TResult Function(bool switched) userSwitchedToBusiness,
  }) {
    return init();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? loading,
    TResult? Function(bool isBusiness)? isUserABusiness,
    TResult? Function(String message)? success,
    TResult? Function(bool switched)? userSwitchedToBusiness,
  }) {
    return init?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(bool isBusiness)? isUserABusiness,
    TResult Function(String message)? success,
    TResult Function(bool switched)? userSwitchedToBusiness,
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
    required TResult Function(DashboardInitState value) init,
    required TResult Function(DashboardLoadingState value) loading,
    required TResult Function(DashboardBusinessState value) isUserABusiness,
    required TResult Function(DashboardSuccessState value) success,
    required TResult Function(DashboardUserSwicthedState value)
        userSwitchedToBusiness,
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DashboardInitState value)? init,
    TResult? Function(DashboardLoadingState value)? loading,
    TResult? Function(DashboardBusinessState value)? isUserABusiness,
    TResult? Function(DashboardSuccessState value)? success,
    TResult? Function(DashboardUserSwicthedState value)? userSwitchedToBusiness,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DashboardInitState value)? init,
    TResult Function(DashboardLoadingState value)? loading,
    TResult Function(DashboardBusinessState value)? isUserABusiness,
    TResult Function(DashboardSuccessState value)? success,
    TResult Function(DashboardUserSwicthedState value)? userSwitchedToBusiness,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class DashboardInitState implements DashboardState {
  const factory DashboardInitState() = _$DashboardInitStateImpl;
}

/// @nodoc
abstract class _$$DashboardLoadingStateImplCopyWith<$Res> {
  factory _$$DashboardLoadingStateImplCopyWith(
          _$DashboardLoadingStateImpl value,
          $Res Function(_$DashboardLoadingStateImpl) then) =
      __$$DashboardLoadingStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DashboardLoadingStateImplCopyWithImpl<$Res>
    extends _$DashboardStateCopyWithImpl<$Res, _$DashboardLoadingStateImpl>
    implements _$$DashboardLoadingStateImplCopyWith<$Res> {
  __$$DashboardLoadingStateImplCopyWithImpl(_$DashboardLoadingStateImpl _value,
      $Res Function(_$DashboardLoadingStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$DashboardLoadingStateImpl implements DashboardLoadingState {
  const _$DashboardLoadingStateImpl();

  @override
  String toString() {
    return 'DashboardState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardLoadingStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(bool isBusiness) isUserABusiness,
    required TResult Function(String message) success,
    required TResult Function(bool switched) userSwitchedToBusiness,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? loading,
    TResult? Function(bool isBusiness)? isUserABusiness,
    TResult? Function(String message)? success,
    TResult? Function(bool switched)? userSwitchedToBusiness,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(bool isBusiness)? isUserABusiness,
    TResult Function(String message)? success,
    TResult Function(bool switched)? userSwitchedToBusiness,
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
    required TResult Function(DashboardInitState value) init,
    required TResult Function(DashboardLoadingState value) loading,
    required TResult Function(DashboardBusinessState value) isUserABusiness,
    required TResult Function(DashboardSuccessState value) success,
    required TResult Function(DashboardUserSwicthedState value)
        userSwitchedToBusiness,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DashboardInitState value)? init,
    TResult? Function(DashboardLoadingState value)? loading,
    TResult? Function(DashboardBusinessState value)? isUserABusiness,
    TResult? Function(DashboardSuccessState value)? success,
    TResult? Function(DashboardUserSwicthedState value)? userSwitchedToBusiness,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DashboardInitState value)? init,
    TResult Function(DashboardLoadingState value)? loading,
    TResult Function(DashboardBusinessState value)? isUserABusiness,
    TResult Function(DashboardSuccessState value)? success,
    TResult Function(DashboardUserSwicthedState value)? userSwitchedToBusiness,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class DashboardLoadingState implements DashboardState {
  const factory DashboardLoadingState() = _$DashboardLoadingStateImpl;
}

/// @nodoc
abstract class _$$DashboardBusinessStateImplCopyWith<$Res> {
  factory _$$DashboardBusinessStateImplCopyWith(
          _$DashboardBusinessStateImpl value,
          $Res Function(_$DashboardBusinessStateImpl) then) =
      __$$DashboardBusinessStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool isBusiness});
}

/// @nodoc
class __$$DashboardBusinessStateImplCopyWithImpl<$Res>
    extends _$DashboardStateCopyWithImpl<$Res, _$DashboardBusinessStateImpl>
    implements _$$DashboardBusinessStateImplCopyWith<$Res> {
  __$$DashboardBusinessStateImplCopyWithImpl(
      _$DashboardBusinessStateImpl _value,
      $Res Function(_$DashboardBusinessStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusiness = null,
  }) {
    return _then(_$DashboardBusinessStateImpl(
      null == isBusiness
          ? _value.isBusiness
          : isBusiness // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$DashboardBusinessStateImpl implements DashboardBusinessState {
  const _$DashboardBusinessStateImpl(this.isBusiness);

  @override
  final bool isBusiness;

  @override
  String toString() {
    return 'DashboardState.isUserABusiness(isBusiness: $isBusiness)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardBusinessStateImpl &&
            (identical(other.isBusiness, isBusiness) ||
                other.isBusiness == isBusiness));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isBusiness);

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardBusinessStateImplCopyWith<_$DashboardBusinessStateImpl>
      get copyWith => __$$DashboardBusinessStateImplCopyWithImpl<
          _$DashboardBusinessStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(bool isBusiness) isUserABusiness,
    required TResult Function(String message) success,
    required TResult Function(bool switched) userSwitchedToBusiness,
  }) {
    return isUserABusiness(isBusiness);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? loading,
    TResult? Function(bool isBusiness)? isUserABusiness,
    TResult? Function(String message)? success,
    TResult? Function(bool switched)? userSwitchedToBusiness,
  }) {
    return isUserABusiness?.call(isBusiness);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(bool isBusiness)? isUserABusiness,
    TResult Function(String message)? success,
    TResult Function(bool switched)? userSwitchedToBusiness,
    required TResult orElse(),
  }) {
    if (isUserABusiness != null) {
      return isUserABusiness(isBusiness);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DashboardInitState value) init,
    required TResult Function(DashboardLoadingState value) loading,
    required TResult Function(DashboardBusinessState value) isUserABusiness,
    required TResult Function(DashboardSuccessState value) success,
    required TResult Function(DashboardUserSwicthedState value)
        userSwitchedToBusiness,
  }) {
    return isUserABusiness(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DashboardInitState value)? init,
    TResult? Function(DashboardLoadingState value)? loading,
    TResult? Function(DashboardBusinessState value)? isUserABusiness,
    TResult? Function(DashboardSuccessState value)? success,
    TResult? Function(DashboardUserSwicthedState value)? userSwitchedToBusiness,
  }) {
    return isUserABusiness?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DashboardInitState value)? init,
    TResult Function(DashboardLoadingState value)? loading,
    TResult Function(DashboardBusinessState value)? isUserABusiness,
    TResult Function(DashboardSuccessState value)? success,
    TResult Function(DashboardUserSwicthedState value)? userSwitchedToBusiness,
    required TResult orElse(),
  }) {
    if (isUserABusiness != null) {
      return isUserABusiness(this);
    }
    return orElse();
  }
}

abstract class DashboardBusinessState implements DashboardState {
  const factory DashboardBusinessState(final bool isBusiness) =
      _$DashboardBusinessStateImpl;

  bool get isBusiness;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardBusinessStateImplCopyWith<_$DashboardBusinessStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DashboardSuccessStateImplCopyWith<$Res> {
  factory _$$DashboardSuccessStateImplCopyWith(
          _$DashboardSuccessStateImpl value,
          $Res Function(_$DashboardSuccessStateImpl) then) =
      __$$DashboardSuccessStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$DashboardSuccessStateImplCopyWithImpl<$Res>
    extends _$DashboardStateCopyWithImpl<$Res, _$DashboardSuccessStateImpl>
    implements _$$DashboardSuccessStateImplCopyWith<$Res> {
  __$$DashboardSuccessStateImplCopyWithImpl(_$DashboardSuccessStateImpl _value,
      $Res Function(_$DashboardSuccessStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$DashboardSuccessStateImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DashboardSuccessStateImpl implements DashboardSuccessState {
  const _$DashboardSuccessStateImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'DashboardState.success(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardSuccessStateImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardSuccessStateImplCopyWith<_$DashboardSuccessStateImpl>
      get copyWith => __$$DashboardSuccessStateImplCopyWithImpl<
          _$DashboardSuccessStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(bool isBusiness) isUserABusiness,
    required TResult Function(String message) success,
    required TResult Function(bool switched) userSwitchedToBusiness,
  }) {
    return success(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? loading,
    TResult? Function(bool isBusiness)? isUserABusiness,
    TResult? Function(String message)? success,
    TResult? Function(bool switched)? userSwitchedToBusiness,
  }) {
    return success?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(bool isBusiness)? isUserABusiness,
    TResult Function(String message)? success,
    TResult Function(bool switched)? userSwitchedToBusiness,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DashboardInitState value) init,
    required TResult Function(DashboardLoadingState value) loading,
    required TResult Function(DashboardBusinessState value) isUserABusiness,
    required TResult Function(DashboardSuccessState value) success,
    required TResult Function(DashboardUserSwicthedState value)
        userSwitchedToBusiness,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DashboardInitState value)? init,
    TResult? Function(DashboardLoadingState value)? loading,
    TResult? Function(DashboardBusinessState value)? isUserABusiness,
    TResult? Function(DashboardSuccessState value)? success,
    TResult? Function(DashboardUserSwicthedState value)? userSwitchedToBusiness,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DashboardInitState value)? init,
    TResult Function(DashboardLoadingState value)? loading,
    TResult Function(DashboardBusinessState value)? isUserABusiness,
    TResult Function(DashboardSuccessState value)? success,
    TResult Function(DashboardUserSwicthedState value)? userSwitchedToBusiness,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class DashboardSuccessState implements DashboardState {
  const factory DashboardSuccessState(final String message) =
      _$DashboardSuccessStateImpl;

  String get message;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardSuccessStateImplCopyWith<_$DashboardSuccessStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DashboardUserSwicthedStateImplCopyWith<$Res> {
  factory _$$DashboardUserSwicthedStateImplCopyWith(
          _$DashboardUserSwicthedStateImpl value,
          $Res Function(_$DashboardUserSwicthedStateImpl) then) =
      __$$DashboardUserSwicthedStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool switched});
}

/// @nodoc
class __$$DashboardUserSwicthedStateImplCopyWithImpl<$Res>
    extends _$DashboardStateCopyWithImpl<$Res, _$DashboardUserSwicthedStateImpl>
    implements _$$DashboardUserSwicthedStateImplCopyWith<$Res> {
  __$$DashboardUserSwicthedStateImplCopyWithImpl(
      _$DashboardUserSwicthedStateImpl _value,
      $Res Function(_$DashboardUserSwicthedStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? switched = null,
  }) {
    return _then(_$DashboardUserSwicthedStateImpl(
      null == switched
          ? _value.switched
          : switched // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$DashboardUserSwicthedStateImpl implements DashboardUserSwicthedState {
  const _$DashboardUserSwicthedStateImpl(this.switched);

  @override
  final bool switched;

  @override
  String toString() {
    return 'DashboardState.userSwitchedToBusiness(switched: $switched)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardUserSwicthedStateImpl &&
            (identical(other.switched, switched) ||
                other.switched == switched));
  }

  @override
  int get hashCode => Object.hash(runtimeType, switched);

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardUserSwicthedStateImplCopyWith<_$DashboardUserSwicthedStateImpl>
      get copyWith => __$$DashboardUserSwicthedStateImplCopyWithImpl<
          _$DashboardUserSwicthedStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(bool isBusiness) isUserABusiness,
    required TResult Function(String message) success,
    required TResult Function(bool switched) userSwitchedToBusiness,
  }) {
    return userSwitchedToBusiness(switched);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? loading,
    TResult? Function(bool isBusiness)? isUserABusiness,
    TResult? Function(String message)? success,
    TResult? Function(bool switched)? userSwitchedToBusiness,
  }) {
    return userSwitchedToBusiness?.call(switched);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(bool isBusiness)? isUserABusiness,
    TResult Function(String message)? success,
    TResult Function(bool switched)? userSwitchedToBusiness,
    required TResult orElse(),
  }) {
    if (userSwitchedToBusiness != null) {
      return userSwitchedToBusiness(switched);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DashboardInitState value) init,
    required TResult Function(DashboardLoadingState value) loading,
    required TResult Function(DashboardBusinessState value) isUserABusiness,
    required TResult Function(DashboardSuccessState value) success,
    required TResult Function(DashboardUserSwicthedState value)
        userSwitchedToBusiness,
  }) {
    return userSwitchedToBusiness(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DashboardInitState value)? init,
    TResult? Function(DashboardLoadingState value)? loading,
    TResult? Function(DashboardBusinessState value)? isUserABusiness,
    TResult? Function(DashboardSuccessState value)? success,
    TResult? Function(DashboardUserSwicthedState value)? userSwitchedToBusiness,
  }) {
    return userSwitchedToBusiness?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DashboardInitState value)? init,
    TResult Function(DashboardLoadingState value)? loading,
    TResult Function(DashboardBusinessState value)? isUserABusiness,
    TResult Function(DashboardSuccessState value)? success,
    TResult Function(DashboardUserSwicthedState value)? userSwitchedToBusiness,
    required TResult orElse(),
  }) {
    if (userSwitchedToBusiness != null) {
      return userSwitchedToBusiness(this);
    }
    return orElse();
  }
}

abstract class DashboardUserSwicthedState implements DashboardState {
  const factory DashboardUserSwicthedState(final bool switched) =
      _$DashboardUserSwicthedStateImpl;

  bool get switched;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardUserSwicthedStateImplCopyWith<_$DashboardUserSwicthedStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
