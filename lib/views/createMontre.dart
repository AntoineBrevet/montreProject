import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:montreproject/main.dart';
import 'package:montreproject/model/montre.dart';
import 'package:http/http.dart' as http;

Future<Montre> createMontre(
    String title, String image, String price, String description) async {
  final response = await http.post(
    Uri.parse(
        'https://my-json-server.typicode.com/AntoineBrevet/MontresApiJson/montres'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'title': title,
      'image': image,
      'price': int.parse(price),
      'description': description,
    }),
  );

  if (response.statusCode == 201) {
    return Montre.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create Montre.');
  }
}

class CreateMontre extends StatefulWidget {
  CreateMontre({Key? key}) : super(key: key);

  @override
  State<CreateMontre> createState() => _CreateMontreState();
}

class _CreateMontreState extends State<CreateMontre> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();

  Future<Montre>? _futureMontre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter un article"),
      ),
      body: (_futureMontre == null)
          ? Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(
                    top: 20,
                    right: 20,
                    left: 20,
                  ),
                  child: TextField(
                    controller: _controller,
                    decoration:
                        const InputDecoration(hintText: 'Entrez un nom'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 20,
                    right: 20,
                    left: 20,
                  ),
                  child: TextField(
                    controller: _controller2,
                    decoration: const InputDecoration(
                        hintText: 'Entrez un lien d\'image'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 20,
                    right: 20,
                    left: 20,
                  ),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _controller3,
                    decoration:
                        const InputDecoration(hintText: 'Entrez un prix'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 20,
                    right: 20,
                    left: 20,
                  ),
                  child: TextField(
                    controller: _controller4,
                    decoration: const InputDecoration(
                        hintText: 'Entrez une description'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 20,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _futureMontre = createMontre(
                            _controller.text,
                            _controller2.text,
                            _controller3.text,
                            _controller4.text);
                      });
                    },
                    child: const Text('Ajouter une montre'),
                  ),
                ),
              ],
            )
          : FutureBuilder<Montre>(
              future: _futureMontre,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            top: 20,
                          ),
                          child: const Text(
                            "Nouvelle montre ajoutée : ",
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(
                              top: 20,
                            ),
                            child: Text(
                              "Nom : ${snapshot.data!.title}",
                              style: const TextStyle(fontSize: 20),
                            )),
                        Container(
                            margin: const EdgeInsets.only(
                              top: 20,
                            ),
                            child: Text(
                              "Lien de l'image : ${snapshot.data!.image}",
                              style: const TextStyle(fontSize: 20),
                            )),
                        Container(
                            margin: const EdgeInsets.only(
                              top: 20,
                            ),
                            child: Text(
                              "Prix de la montre : ${snapshot.data!.price} €",
                              style: const TextStyle(fontSize: 20),
                            )),
                        Container(
                          margin: const EdgeInsets.only(
                            top: 20,
                          ),
                          child: Text(
                            "Description de la montre : ${snapshot.data!.description}",
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                return const CircularProgressIndicator();
              },
            ),
    );
  }
}
