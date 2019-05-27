class SadhanaType {
  final int index;
  final String serverValue;
  const SadhanaType._internal(this.index, this.serverValue);

  static const BOOLEAN = const SadhanaType._internal(0,'Boolean');
  static const NUMBER = const SadhanaType._internal(1,'Number');
}