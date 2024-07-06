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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _avatarController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    if (widget.person != null) {
      _emailController.text = widget.person['email'] ?? '';
      _firstNameController.text = widget.person['first_name'] ?? '';
      _lastNameController.text = widget.person['last_name'] ?? '';
      _avatarController.text = widget.person['avatar'] ?? '';
      _isUpdating = true;
    }
  }

  void _saveOrUpdatePerson() async {
    try {
      dynamic result;
      if (_isUpdating) {
        result = await _apiService.updatePerson(
          widget.person['id'],
          _emailController.text,
          _firstNameController.text,
          _lastNameController.text,
          _avatarController.text
        );
      } else {
        result = await _apiService.createPerson(
          _emailController.text,
          _firstNameController.text,
          _lastNameController.text,
          _avatarController.text
        );
      }
      if (result != null) {
        widget.onSaved(); // Llama al callback para refrescar la lista si es necesario
        Navigator.pop(context, result); // Retorna el objeto persona actualizado o creado
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
              ),
              TextField(
                controller: _avatarController,
                decoration: InputDecoration(labelText: 'Avatar URL'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveOrUpdatePerson,
                child: Text(_isUpdating ? 'Update' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
