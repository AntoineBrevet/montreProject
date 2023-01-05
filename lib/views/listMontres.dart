import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:montreproject/model/montre.dart';
import 'package:montreproject/views/singleMontre.dart';

List<Montre> parseMontres(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Montre>((json) => Montre.fromJson(json)).toList();
}

Future<List<Montre>> showAllMontres() async {
  final response = await http.get(Uri.parse(
      'https://my-json-server.typicode.com/AntoineBrevet/MontresApiJson/montres'));

  if (response.statusCode == 200) {
    return compute(parseMontres, response.body);
  } else {
    throw Exception('J\'ai pas réussi frère');
  }
}

class ListMontres extends StatefulWidget {
  ListMontres({Key? key}) : super(key: key);

  @override
  State<ListMontres> createState() => _ListMontresState();
}

class _ListMontresState extends State<ListMontres> {
  late Future<List<Montre>> futureMontre;

  @override
  void initState() {
    super.initState();
    futureMontre = showAllMontres();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<Montre>>(
        future: futureMontre,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MontresList(montres: snapshot.data!);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

class MontresList extends StatelessWidget {
  const MontresList({super.key, required this.montres});

  final List<Montre> montres;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: montres.length,
      itemBuilder: (context, index) {
        return SizedBox(
          height: 70,
          child: Card(
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SingleMontre(id: montres[index].id),
                  ),
                );
              },
              leading: Image.network(
                montres[index].image,
                height: 70,
              ),
              title: Text(montres[index].title),
              trailing: Text("${montres[index].price} €"),
            ),
          ),
        );
      },
    );
  }
}
