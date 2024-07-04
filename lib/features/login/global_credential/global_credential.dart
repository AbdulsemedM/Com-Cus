class GlobalCredential {
  static Map<String, dynamic> _globalCredential = {};

  static void setGlobalString(Map<String, dynamic> value) {
    _globalCredential = value;
    print("set Success");
  }

  static Map<String, dynamic> getGlobalString() {
    return _globalCredential;
  }
}
