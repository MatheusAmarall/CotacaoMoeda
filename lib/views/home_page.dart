import 'package:cotacaomoedas/views/favorites.dart';
import 'package:flutter/material.dart';
import '../services/request_http.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List favorites = [];
  TextEditingController filterController = TextEditingController();

  void addFavorite(String code) {
    if (favorites.contains(code)) {
      setState(() => {favorites.remove(code)});
    }
    else {
      setState(() => {favorites.add(code)});
    }
  }

  void navigateFavorites() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Favorites(
                  favorites: favorites,
                )));
  }

  void filtrar(String filtro) {
    setState(() => {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Moedas"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: filterController,
              decoration: InputDecoration(
                labelText: 'Filtrar',
                border: OutlineInputBorder(),
              ),
              onSubmitted: filtrar,
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getCotacao(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  List<String> indexMoedas = snapshot.data.keys.toList();
                  List<String> moedasFiltradas = indexMoedas.where((moeda) => moeda.contains(filterController.text)).toList();
                  return ListView.builder(
                    itemCount: moedasFiltradas.length,
                    itemBuilder: (context, index) {
                      var moeda = snapshot.data[moedasFiltradas[index]];
          
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GestureDetector(
                          onLongPress: () =>
                              addFavorite('${moeda['code']}-${moeda['codein']}'),
                          child: Card(
                            elevation: 10,
                            color: Colors.grey,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 12),
                                    Padding(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        '${moeda['name']}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        '${moeda['code']}-${moeda['codein']}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        'Mínimo do dia: R\$ ${moeda['low']}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        'Máximo do dia: R\$ ${moeda['high']}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        'Valor Atual: R\$ ${moeda['bid']}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  favorites.contains(
                                          '${moeda['code']}-${moeda['codein']}')
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.yellow,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateFavorites,
        backgroundColor: Colors.yellow,
        child: Icon(Icons.star),
      ),
    );
  }
}
