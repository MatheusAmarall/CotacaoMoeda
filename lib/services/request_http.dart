import 'dart:convert';
import 'package:http/http.dart' as http;

getCotacao() async {
  var url = Uri.parse('https://economia.awesomeapi.com.br/all');
  var response = await http.get(url);
  return (jsonDecode(response.body));
}

getEspecifyCotacao(moedas) async {
  print(moedas);
  String parametros = moedas.join(',');
  print(parametros);
  var url = Uri.parse('http://economia.awesomeapi.com.br/json/last/${parametros}');
  var response = await http.get(url);
  return (jsonDecode(response.body));
}