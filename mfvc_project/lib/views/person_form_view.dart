import 'package:flutter/material.dart';
import '../services/api_service.dart';

class PersonFormView extends StatefulWidget {
  final dynamic person;
  final VoidCallback onSaved;

  PersonFormView({this.person, required this.onSaved});

  @override
  _PersonFormViewState createState() => _PersonFormViewState();
}

class _PersonFormViewState extends State<PersonFormView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    if (widget.person != null) {
      _nameController.text = widget.person['first_name'];
      _jobController.text = widget.person['job'] ?? '';
      _isUpdating = true;
    }
  }

  void _saveOrUpdatePerson() async {
    try {
      dynamic result;
      if (_isUpdating) {
        result = await _apiService.updatePerson(widget.person['id'], _nameController.text, _jobController.text);
      } else {
        result = await _apiService.createPerson(_nameController.text, _jobController.text);
      }
      if (result != null) {
        widget.onSaved(); // Llama al callback para refrescar la lista si es necesario
        Navigator.pop(context, result); // Retorna el objeto persona actualizado
      } else {
        throw Exception("Failed to save the person");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isUpdating ? 'Edit Person' : 'Add Person'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _jobController,
              decoration: InputDecoration(labelText: 'Job'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveOrUpdatePerson,
              child: Text(_isUpdating ? 'Update' : 'Save'),
            )
          ],
        ),
      ),
    );
  }
}
