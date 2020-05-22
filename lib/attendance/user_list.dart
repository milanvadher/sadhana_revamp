import 'package:flutter/material.dart';
import 'package:sadhana/attendance/model/event_bkp.dart';

class UserList extends StatefulWidget {
  final Event event;

  const UserList({Key key, @required this.event}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  Widget userTile({
    @required String name,
    bool isChecked = false,
  }) {
    return ListTile(
      title: Text(name),
      trailing: Checkbox(
        activeColor: Colors.red.shade500,
        value: isChecked,
        onChanged: (value) {
          isChecked = value;
        },
      ),
      onTap: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: Text(widget.event.eventName),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white30,
              border: Border(
                top: BorderSide(
                  width: 0.0,
                ),
              ),
            ),
            child: ListTile(
              title: Text(
                'Select ALL',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              trailing: Checkbox(
                activeColor: Colors.amber,
                checkColor: Colors.black,
                value: false,
                onChanged: (value) {},
              ),
              onTap: () {},
              selected: true,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          itemCount: 20,
          itemBuilder: (context, index) {
            if (index == 19) {
              return Container(
                margin: EdgeInsets.only(bottom: 80),
                child: userTile(name: 'Fname Lname ${index + 1}'),
              );
            }
            return userTile(name: 'Fname Lname ${index + 1}');
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 0,
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Row(
          children: <Widget>[
            Icon(
              Icons.done,
              color: Colors.white,
            ),
            Text(
              'SAVE',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
