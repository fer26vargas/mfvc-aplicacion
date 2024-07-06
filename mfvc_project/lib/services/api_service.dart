import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = 'https://reqres.in/api';

  Future<bool> login(String email, String password) async {
    var response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {
        'email': email,
        'password': password,
      },
    );
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<List<dynamic>> getPersons() async {
    var response = await http.get(Uri.parse('$baseUrl/users?page=2'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data['data'];  
    } else {
      throw Exception('Failed to load persons');
    }
  }

  Future<dynamic> createPerson(String name, String job) async {
    var url = Uri.parse('$baseUrl/users'); 
    var response = await http.post(
      url,
      body: jsonEncode({
        'name': name,
        'job': job
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body); 
    } else {
      throw Exception('Failed to create person. Status code: ${response.statusCode}');
    }
  }

  Future<dynamic> updatePerson(int id, String name, String job) async {
    var url = Uri.parse('$baseUrl/users/$id');
    var response = await http.put(
      url,
      body: jsonEncode({
        'name': name,
        'job': job
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body); 
    } else {
      throw Exception('Failed to update person. Status code: ${response.statusCode}');
    }
  }

  Future<void> deletePerson(int id) async {
    var url = Uri.parse('$baseUrl/users/$id');
    var response = await http.delete(url);
    
    if (response.statusCode != 204) { 
      throw Exception('Failed to delete person. Status code: ${response.statusCode}');
    }
  }
}
