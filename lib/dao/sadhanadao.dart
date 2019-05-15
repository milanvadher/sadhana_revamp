import 'package:sadhana/dao/basedao.dart';
import 'package:sadhana/model/entity.dart';
import 'package:sadhana/model/sadhana.dart';

class SadhanaDAO extends BaseDAO<Sadhana> {
  static final createSadhanaTable = ''' create table ${Sadhana.tableSadhana} ( 
  ${Entity.columnId} integer primary key autoincrement, 
  ${Sadhana.columnName} text not null,
  ${Sadhana.columnDescription} text,
  ${Sadhana.columnIndex} integer not null,
  ${Sadhana.columnLColor} integer not null,
  ${Sadhana.columnDColor} integer not null,
  ${Sadhana.columnType} integer not null,
  ${Sadhana.columnIsPreloaded} boolean,
  ${Sadhana.columnReminderTime} date,
  ${Sadhana.columnReminderDays} text)
''';

  @override
  getDefaultInstance() {
    return Sadhana();
  }

  @override
  getTableName() {
    return Sadhana.tableSadhana;
  }

}