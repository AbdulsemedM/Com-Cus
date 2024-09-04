abstract class OtpPaymentRepo {
  Future<String> accountLookUp(String phoneNumber,String serviceCode);
  Future<String> paymentCheckOut(String phoneNumber,String paymentMethod);
  Future<String> confirmPaymentCheckOut(String transRef, String otp);
}
