abstract class AffiliateRegisterState {}

class AffiliateRegisterInitial extends AffiliateRegisterState {}

class AffiliateRegisterLoading extends AffiliateRegisterState {}

class AffiliateRegisterSuccess extends AffiliateRegisterState {
  final String message;
  
  AffiliateRegisterSuccess(this.message);
}

class AffiliateRegisterError extends AffiliateRegisterState {
  final String message;
  
  AffiliateRegisterError(this.message);
}