import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/person_card.dart';
import 'person_form_view.dart'; 

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ApiService _apiService = ApiService();
  List<dynamic> _persons = [];

  @override
  void initState() {
    super.initState();
    _loadPersons();
  }

  void _loadPersons() async {
    try {
      List<dynamic> persons = await _apiService.getPersons();
      setState(() {
        _persons = persons;
      });
    } catch (e) {
      print(e);
    }
  }

  void _deletePerson(int id) {
    setState(() {
      _persons.removeWhere((person) => person['id'] == id);
    });
  }

  void _handlePersonUpdate(dynamic updatedPerson) {
    int index = _persons.indexWhere((person) => person['id'] == updatedPerson['id']);
    if (index != -1) {
      setState(() {
        _persons[index] = updatedPerson;
      });
    }
  }

  void _editPerson(int index) async {
    final updatedPerson = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonFormView(
          person: _persons[index],
          onSaved: _loadPersons,
        ),
      ),
    );
    if (updatedPerson != null) {
      _handlePersonUpdate(updatedPerson);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Person List")),
      body: ListView.builder(
        itemCount: _persons.length,
        itemBuilder: (context, index) {
          return PersonCard(
            person: _persons[index],
            onEdit: () => _editPerson(index),
            onDelete: () => _deletePerson(_persons[index]['id']),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PersonFormView(onSaved: _loadPersons)),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add New Person',
      ),
    );
  }
}
