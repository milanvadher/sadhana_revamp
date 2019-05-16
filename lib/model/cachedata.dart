import 'package:sadhana/model/sadhana.dart';

class CacheData {

  static List<Sadhana> _sadhanas = new List();

  static List<Sadhana> getSadhanas() {
    return _sadhanas;
  }

  static addSadhanas(List<Sadhana> sadhanas) {
    _sadhanas.addAll(sadhanas);
  }

  static removeSadhana(int id) {
    _sadhanas.removeWhere((sadhana) => sadhana.id == id);
  }


}


