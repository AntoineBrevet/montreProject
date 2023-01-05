import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:montreproject/model/montre.dart';
import 'package:http/http.dart' as http;

Future<Montre> showMontre(int id) async {
  final response = await http.get(Uri.parse(
      "https://my-json-server.typicode.com/AntoineBrevet/MontresApiJson/montres/$id"));

  if (response.statusCode == 200) {
    return Montre.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('J\'ai pas réussi frère');
  }
}

class SingleMontre extends StatefulWidget {
  SingleMontre({Key? key, required this.id}) : super(key: key);

  final int id;
  @override
  State<SingleMontre> createState() => _SingleMontreState();
}

class _SingleMontreState extends State<SingleMontre> {
  late Future<Montre> futureMontre;

  @override
  void initState() {
    super.initState();
    futureMontre = showMontre(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Montrer une montre"),
      ),
      body: FutureBuilder<Montre>(
        future: futureMontre,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MontreDetail(montre: snapshot.data!);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

class MontreDetail extends StatelessWidget {
  const MontreDetail({super.key, required this.montre});

  final Montre montre;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(
            top: 20,
            bottom: 20,
          ),
          child: Text(
            montre.title,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
            bottom: 20,
          ),
          child: Image.network(
            montre.image,
            height: 200,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
            bottom: 20,
          ),
          child: Text(
            "Prix :${montre.price} €",
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        Text(
          "Description : ${montre.description}",
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
