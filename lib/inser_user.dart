import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InsertUser extends StatefulWidget {

  InsertUser(this.map);

  Map? map;

  @override
  State<InsertUser> createState() => _InsertUserState();
}

class _InsertUserState extends State<InsertUser> {
  var formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();

  var phoneNoController = TextEditingController();

  var CityController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.map ==null?'':widget.map!['name'];
    phoneNoController.text = widget.map ==null?'':widget.map!['phoneNo'];
    CityController.text = widget.map ==null?'':widget.map!['City'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(hintText: 'Enter Name'),
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return "Enter Valid Name";
                }
              },
              controller: nameController,
            ),
            TextFormField(
              decoration: InputDecoration(hintText: 'Enter phoneNo'),
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return "Enter Valid phoneNo";
                }
              },
              controller: phoneNoController,
            ),
            TextFormField(
              decoration: InputDecoration(hintText: 'Enter City'),
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return "Enter Valid City";
                }
              },
              controller: CityController,
            ),
            TextButton(
                onPressed: ()  {
                  if (formKey.currentState!.validate()) {
                    if(widget.map == null){
                      insertUser().then((value) => Navigator.of(context).pop(true));
                    }else{
                      updateUser(widget.map!['id']).then((value) => Navigator.of(context).pop(true));
                    }
                  }
                },
                child: Text('Submit'))
          ],
        ),
      ),
    );
  }

  Future<void> updateUser(id) async {
    Map map = {};
    map["name"] = nameController.text;
    map["phoneNo"] = phoneNoController.text;
    map["City"] = CityController.text;

    var response1 = await http.put(
        Uri.parse("https://63fdad491626c165a09d3fe5.mockapi.io/user/$id"),
        body: map);
    print(response1.body);
  }

  Future<void> insertUser() async {
    Map map = {};
    map["name"] = nameController.text;
    map["phoneNo"] = phoneNoController.text;
    map["City"] = CityController.text;

    var response1 = await http.post(
        Uri.parse("https://63fdad491626c165a09d3fe5.mockapi.io/user"),
        body: map);
    print(response1.body);
  }
}
