abstract class RedirectedPaymentRepo{
  Future<String> getPaymentApi(String cashType, String? phone);
}