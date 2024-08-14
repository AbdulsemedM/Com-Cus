// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() userNotLoggedIn,
    required TResult Function(UserModel userModel) user,
    required TResult Function(String error) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? userNotLoggedIn,
    TResult? Function(UserModel userModel)? user,
    TResult? Function(String error)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? userNotLoggedIn,
    TResult Function(UserModel userModel)? user,
    TResult Function(String error)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserStateInit value) init,
    required TResult Function(UserStateNotLoggedIn value) userNotLoggedIn,
    required TResult Function(UserStateData value) user,
    required TResult Function(UserStateError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserStateInit value)? init,
    TResult? Function(UserStateNotLoggedIn value)? userNotLoggedIn,
    TResult? Function(UserStateData value)? user,
    TResult? Function(UserStateError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserStateInit value)? init,
    TResult Function(UserStateNotLoggedIn value)? userNotLoggedIn,
    TResult Function(UserStateData value)? user,
    TResult Function(UserStateError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStateCopyWith<$Res> {
  factory $UserStateCopyWith(UserState value, $Res Function(UserState) then) =
      _$UserStateCopyWithImpl<$Res, UserState>;
}

/// @nodoc
class _$UserStateCopyWithImpl<$Res, $Val extends UserState>
    implements $UserStateCopyWith<$Res> {
  _$UserStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$UserStateInitImplCopyWith<$Res> {
  factory _$$UserStateInitImplCopyWith(
          _$UserStateInitImpl value, $Res Function(_$UserStateInitImpl) then) =
      __$$UserStateInitImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UserStateInitImplCopyWithImpl<$Res>
    extends _$UserStateCopyWithImpl<$Res, _$UserStateInitImpl>
    implements _$$UserStateInitImplCopyWith<$Res> {
  __$$UserStateInitImplCopyWithImpl(
      _$UserStateInitImpl _value, $Res Function(_$UserStateInitImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UserStateInitImpl implements UserStateInit {
  const _$UserStateInitImpl();

  @override
  String toString() {
    return 'UserState.init()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UserStateInitImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() userNotLoggedIn,
    required TResult Function(UserModel userModel) user,
    required TResult Function(String error) error,
  }) {
    return init();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? userNotLoggedIn,
    TResult? Function(UserModel userModel)? user,
    TResult? Function(String error)? error,
  }) {
    return init?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? userNotLoggedIn,
    TResult Function(UserModel userModel)? user,
    TResult Function(String error)? error,
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
    required TResult Function(UserStateInit value) init,
    required TResult Function(UserStateNotLoggedIn value) userNotLoggedIn,
    required TResult Function(UserStateData value) user,
    required TResult Function(UserStateError value) error,
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserStateInit value)? init,
    TResult? Function(UserStateNotLoggedIn value)? userNotLoggedIn,
    TResult? Function(UserStateData value)? user,
    TResult? Function(UserStateError value)? error,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserStateInit value)? init,
    TResult Function(UserStateNotLoggedIn value)? userNotLoggedIn,
    TResult Function(UserStateData value)? user,
    TResult Function(UserStateError value)? error,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class UserStateInit implements UserState {
  const factory UserStateInit() = _$UserStateInitImpl;
}

/// @nodoc
abstract class _$$UserStateNotLoggedInImplCopyWith<$Res> {
  factory _$$UserStateNotLoggedInImplCopyWith(_$UserStateNotLoggedInImpl value,
          $Res Function(_$UserStateNotLoggedInImpl) then) =
      __$$UserStateNotLoggedInImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UserStateNotLoggedInImplCopyWithImpl<$Res>
    extends _$UserStateCopyWithImpl<$Res, _$UserStateNotLoggedInImpl>
    implements _$$UserStateNotLoggedInImplCopyWith<$Res> {
  __$$UserStateNotLoggedInImplCopyWithImpl(_$UserStateNotLoggedInImpl _value,
      $Res Function(_$UserStateNotLoggedInImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UserStateNotLoggedInImpl implements UserStateNotLoggedIn {
  const _$UserStateNotLoggedInImpl();

  @override
  String toString() {
    return 'UserState.userNotLoggedIn()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserStateNotLoggedInImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() userNotLoggedIn,
    required TResult Function(UserModel userModel) user,
    required TResult Function(String error) error,
  }) {
    return userNotLoggedIn();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? userNotLoggedIn,
    TResult? Function(UserModel userModel)? user,
    TResult? Function(String error)? error,
  }) {
    return userNotLoggedIn?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? userNotLoggedIn,
    TResult Function(UserModel userModel)? user,
    TResult Function(String error)? error,
    required TResult orElse(),
  }) {
    if (userNotLoggedIn != null) {
      return userNotLoggedIn();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserStateInit value) init,
    required TResult Function(UserStateNotLoggedIn value) userNotLoggedIn,
    required TResult Function(UserStateData value) user,
    required TResult Function(UserStateError value) error,
  }) {
    return userNotLoggedIn(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserStateInit value)? init,
    TResult? Function(UserStateNotLoggedIn value)? userNotLoggedIn,
    TResult? Function(UserStateData value)? user,
    TResult? Function(UserStateError value)? error,
  }) {
    return userNotLoggedIn?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserStateInit value)? init,
    TResult Function(UserStateNotLoggedIn value)? userNotLoggedIn,
    TResult Function(UserStateData value)? user,
    TResult Function(UserStateError value)? error,
    required TResult orElse(),
  }) {
    if (userNotLoggedIn != null) {
      return userNotLoggedIn(this);
    }
    return orElse();
  }
}

abstract class UserStateNotLoggedIn implements UserState {
  const factory UserStateNotLoggedIn() = _$UserStateNotLoggedInImpl;
}

/// @nodoc
abstract class _$$UserStateDataImplCopyWith<$Res> {
  factory _$$UserStateDataImplCopyWith(
          _$UserStateDataImpl value, $Res Function(_$UserStateDataImpl) then) =
      __$$UserStateDataImplCopyWithImpl<$Res>;
  @useResult
  $Res call({UserModel userModel});
}

/// @nodoc
class __$$UserStateDataImplCopyWithImpl<$Res>
    extends _$UserStateCopyWithImpl<$Res, _$UserStateDataImpl>
    implements _$$UserStateDataImplCopyWith<$Res> {
  __$$UserStateDataImplCopyWithImpl(
      _$UserStateDataImpl _value, $Res Function(_$UserStateDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userModel = null,
  }) {
    return _then(_$UserStateDataImpl(
      null == userModel
          ? _value.userModel
          : userModel // ignore: cast_nullable_to_non_nullable
              as UserModel,
    ));
  }
}

/// @nodoc

class _$UserStateDataImpl implements UserStateData {
  const _$UserStateDataImpl(this.userModel);

  @override
  final UserModel userModel;

  @override
  String toString() {
    return 'UserState.user(userModel: $userModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserStateDataImpl &&
            (identical(other.userModel, userModel) ||
                other.userModel == userModel));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userModel);

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserStateDataImplCopyWith<_$UserStateDataImpl> get copyWith =>
      __$$UserStateDataImplCopyWithImpl<_$UserStateDataImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() userNotLoggedIn,
    required TResult Function(UserModel userModel) user,
    required TResult Function(String error) error,
  }) {
    return user(userModel);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? userNotLoggedIn,
    TResult? Function(UserModel userModel)? user,
    TResult? Function(String error)? error,
  }) {
    return user?.call(userModel);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? userNotLoggedIn,
    TResult Function(UserModel userModel)? user,
    TResult Function(String error)? error,
    required TResult orElse(),
  }) {
    if (user != null) {
      return user(userModel);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserStateInit value) init,
    required TResult Function(UserStateNotLoggedIn value) userNotLoggedIn,
    required TResult Function(UserStateData value) user,
    required TResult Function(UserStateError value) error,
  }) {
    return user(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserStateInit value)? init,
    TResult? Function(UserStateNotLoggedIn value)? userNotLoggedIn,
    TResult? Function(UserStateData value)? user,
    TResult? Function(UserStateError value)? error,
  }) {
    return user?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserStateInit value)? init,
    TResult Function(UserStateNotLoggedIn value)? userNotLoggedIn,
    TResult Function(UserStateData value)? user,
    TResult Function(UserStateError value)? error,
    required TResult orElse(),
  }) {
    if (user != null) {
      return user(this);
    }
    return orElse();
  }
}

abstract class UserStateData implements UserState {
  const factory UserStateData(final UserModel userModel) = _$UserStateDataImpl;

  UserModel get userModel;

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserStateDataImplCopyWith<_$UserStateDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UserStateErrorImplCopyWith<$Res> {
  factory _$$UserStateErrorImplCopyWith(_$UserStateErrorImpl value,
          $Res Function(_$UserStateErrorImpl) then) =
      __$$UserStateErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String error});
}

/// @nodoc
class __$$UserStateErrorImplCopyWithImpl<$Res>
    extends _$UserStateCopyWithImpl<$Res, _$UserStateErrorImpl>
    implements _$$UserStateErrorImplCopyWith<$Res> {
  __$$UserStateErrorImplCopyWithImpl(
      _$UserStateErrorImpl _value, $Res Function(_$UserStateErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
  }) {
    return _then(_$UserStateErrorImpl(
      null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$UserStateErrorImpl implements UserStateError {
  const _$UserStateErrorImpl(this.error);

  @override
  final String error;

  @override
  String toString() {
    return 'UserState.error(error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserStateErrorImpl &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserStateErrorImplCopyWith<_$UserStateErrorImpl> get copyWith =>
      __$$UserStateErrorImplCopyWithImpl<_$UserStateErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() userNotLoggedIn,
    required TResult Function(UserModel userModel) user,
    required TResult Function(String error) error,
  }) {
    return error(this.error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? userNotLoggedIn,
    TResult? Function(UserModel userModel)? user,
    TResult? Function(String error)? error,
  }) {
    return error?.call(this.error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? userNotLoggedIn,
    TResult Function(UserModel userModel)? user,
    TResult Function(String error)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this.error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserStateInit value) init,
    required TResult Function(UserStateNotLoggedIn value) userNotLoggedIn,
    required TResult Function(UserStateData value) user,
    required TResult Function(UserStateError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserStateInit value)? init,
    TResult? Function(UserStateNotLoggedIn value)? userNotLoggedIn,
    TResult? Function(UserStateData value)? user,
    TResult? Function(UserStateError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserStateInit value)? init,
    TResult Function(UserStateNotLoggedIn value)? userNotLoggedIn,
    TResult Function(UserStateData value)? user,
    TResult Function(UserStateError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class UserStateError implements UserState {
  const factory UserStateError(final String error) = _$UserStateErrorImpl;

  String get error;

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserStateErrorImplCopyWith<_$UserStateErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
