import 'package:bids_notification/show%20notification.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';

class Bids extends StatefulWidget {
  const Bids({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => Bidsstate();
}

late Service service;
String? _temp;

class Bidsstate extends State<Bids> {
  Future<Bid>? _futureBid;

  @override
  void initState() {
    service = Service();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _futureBids;
    return MaterialApp(
      title: 'Bids Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My Bids'),
        ),
        body: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<String>(
                builder: (context, AsyncSnapshot<String> snapshot) =>
                    showBidDetails(snapshot),
                future: service.getBid(0),
              ),
            ),
            FutureBuilder(
              future: _showNotification(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future _showNotification() async {
    Notify().notify("title", "content");
  }

  _onNotificationClicked() {}

// void onSelected(var destination) {
//   Navigator.push(
//       context,
//       MaterialPageRoute(
//           settings: const RouteSettings(
//             arguments: {'arg': 0},
//           ),
//           builder: (context) => destination));
// }

  Widget showBidDetails(AsyncSnapshot<String> snapshot) {
    if (snapshot.hasData) {
      //Your downloaded page
      _temp = snapshot.data;
      int count = service._parseHtmlString(_temp!);
      print(count);

      if (count >= 3) _showNotification();
      // card-Header
      // card-body
      // card
      // print(snapshot.data);
      return Container(
          child: Center(
              child: titles.length == 0
                  ? Text('data')
                  : ListView.builder(
                      itemCount: size,
                      itemBuilder: (BuildContext context, int index) {
                        return Center(
                          child: Column(
                            children: [
                              Text(
                                titles[index],
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        );
                      },
                    )));
    } else if (snapshot.hasError) return Text('ERROR $snapshot.hasError');

    return Text('LOADING');
  }
}

List<String> titles = [];
late int size;
late Map<String, String> _headers;

abstract class Api {
  Future<String> login();
  Future<String> getBid(int id);
  Future<List<Bid>> getBids();
}

class Service implements Api {
  @override
  Future<String> getBid(int id) async {
    Response response = await get(
        Uri.parse('http://www.sudabids.com/category/khdmat-istsharyh'));
    if (response.statusCode == 200) {
      // print(response.body);
      login();
      return response.body;
    } else {
      throw Exception('error');
    }
  }

  int _parseHtmlString(String htmlString) {
    var document = parse(htmlString);
    if (document.body == null) {
      return -1;
    } else {
      document.getElementsByClassName('cards-container').forEach((element) {
        size = element.getElementsByClassName('row').length;
        // if (size > 5) _showNotification();
        element.getElementsByClassName('row').forEach((element) {
          // print();

          print(_parseHtmlString(element.innerHtml));
          // titles.add(_parseHtmlString(element.innerHtml));
        });
      });
      String parsedString = parse(document.body!.text).documentElement!.text;
      print(parsedString);
      return size;
    }
  }

  @override
  Future<String> login() async {
    var res = await post(
      Uri.parse('http://www.sudabids.com/login'),
      body: <String, String>{
        'name': 'dar consult',
        'password': 'Atp12345',
      },
    );
    // 419
    // print(res.body);
    if (res.statusCode == 201) {
      // print(res.statusCode);
      return res.body;
    } else {
      return "error";
    }
  }

  @override
  Future<List<Bid>> getBids() {
    // TODO: implement getBids
    throw UnimplementedError();
  }
}

class Bid {
  final int id;
  final String title;
  final String postdate;
  final String expiredate;
  final String body;

  Bid(this.postdate, this.expiredate,
      {required this.id, required this.title, required this.body});

  // factory Bid.fromJson(Map<String, dynamic> json) {
  //   return Bid(
  //     id: json['id'],
  //     title: json['title'],
  //     body: json['body'],
  //   );
  // }
}
