import 'dart:math';

class Version implements Comparable<Version> {
  String version;

  String get() {
    return this.version;
  }

  Version({this.version});

  @override
  int compareTo(Version that) {
    if (that == null) return 1;
    List<String> thisParts = this.get().split(".");
    List<String> thatParts = that.get().split(".");
    int length = max(thisParts.length, thatParts.length);
    for (int i = 0; i < length; i++) {
      int thisPart = i < thisParts.length ? int.parse(thisParts[i]) : 0;
      int thatPart = i < thatParts.length ? int.parse(thatParts[i]) : 0;
      if (thisPart < thatPart) return -1;
      if (thisPart > thatPart) return 1;
    }
    return 0;
  }

  @override
  bool equals(Object that) {
    if (this == that) return true;
    if (that == null) return false;
    return this.compareTo(that as Version) == 0;
  }
}
