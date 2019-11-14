import 'package:database_intro/models/user.dart';
import 'package:database_intro/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

List _users;
void main() async{

  var db = new DatabaseHelper();

  //Add User
  //await db.saveUser(new User('Malik Hassan','Rauf Awan'));

  //int count = await db.getCount();

  //Delete a User
  //int userDeleted = await db.deleteUser(3);
  //print("User Deleted: $userDeleted");

  //Retrieving a User
  User jamesUpdated = User.fromMap({
    "username": "Michael Khan Gajjni",
    "password": "Nothing",
    "id"      : 2
  });

  //Updated
  await db.updateUser(jamesUpdated);

  //Get All Users
  _users = await db.getAllUsers();
  for(int i=0; i<_users.length;i++){
    User user = User.map(_users[i]);
    print("Username: ${user.username}, User Id: ${user.id}");
  }

  runApp(new MaterialApp(
    title: 'Database',
    home: new Home(),
  ));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Database'),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
      ),

      body: new ListView.builder(
          itemCount: _users.length,
          itemBuilder: (BuildContext context,int position){
            return new Card(
              color: Colors.white,
              elevation: 2.0,
              child: new ListTile(
                leading: new CircleAvatar(
                  child: new Text("${User.fromMap(_users[position]).username.substring(0,1)}"),
                ),
                title: new Text("${User.fromMap(_users[position]).username}"),
                subtitle: new Text("${User.fromMap(_users[position]).id}"),

                onTap: () => debugPrint("${User.fromMap(_users[position]).username}"),
              ),
            );
          }),

    );
  }
}
