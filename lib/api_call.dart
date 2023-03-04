import 'dart:convert';

import 'package:api_project/inser_user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ApiCall extends StatefulWidget {
  const ApiCall({Key? key}) : super(key: key);

  @override
  State<ApiCall> createState() => _ApiState();
}

class _ApiState extends State<ApiCall> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 24,
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return InsertUser(null);
                  },
                ),
              ).then((value) {
                if (value == true) {
                  setState(() {});
                }
              });
            },
          )
        ],
      ),
      body: FutureBuilder<http.Response>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> datas = jsonDecode(snapshot.data!.body.toString());
            datas.reversed;
            return ListView.builder(
              itemCount: jsonDecode(snapshot.data!.body.toString()).length,
              itemBuilder: (context, index) {
                return Card(
                    color: index % 2 == 0
                        ? Colors.lightBlueAccent
                        : Colors.lightBlue,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (jsonDecode(snapshot.data!.body.toString())[
                                          index]['name'])
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                ),
                                Text(
                                  (jsonDecode(snapshot.data!.body.toString())[
                                          index]['City'])
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                                Text(
                                  (jsonDecode(snapshot.data!.body.toString())[
                                          index]['phoneNo'])
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white60),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            child: Icon(
                              Icons.delete,
                              color: Colors.red.shade300,
                            ),
                            onTap: () {
                              showDeleteAlert((jsonDecode(
                                      snapshot.data!.body.toString())[index]
                                  ['id']));
                            },
                          ),
                          InkWell(
                            child: Icon(
                              Icons.chevron_right,
                              color: Colors.grey.shade300,
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) {
                                  return InsertUser(jsonDecode(
                                      snapshot.data!.body.toString())[index]);
                                },
                              )).then((value) {
                                setState(() {});
                              });
                            },
                          )
                        ],
                      ),
                    ));
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        future: getDataFromWebServer(),
      ),
    );
  }

  void showDeleteAlert(id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('Are you sure want to delte'),
          actions: [
            TextButton(
                onPressed: () async {
                  http.Response res = await deleteUserFromWeb(id);
                  if (res.statusCode == 200) {
                    setState(() {});
                  }
                  Navigator.of(context).pop();
                },
                child: Text('Yes')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('No')),
          ],
        );
      },
    );
  }

  Future<http.Response> deleteUserFromWeb(id) async {
    var response = await http.delete(
        Uri.parse("https://63fdad491626c165a09d3fe5.mockapi.io/user/$id"));

    return response;
  }

  Future<http.Response> getDataFromWebServer() async {
    var response = await http
        .get(Uri.parse("https://63fdad491626c165a09d3fe5.mockapi.io/user"));

    return response;
  }
}
