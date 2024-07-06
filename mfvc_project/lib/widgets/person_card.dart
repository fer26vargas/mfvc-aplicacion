import 'package:flutter/material.dart';
import '../services/api_service.dart';

class PersonCard extends StatelessWidget {
  final dynamic person;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  PersonCard({required this.person, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    ApiService apiService = ApiService();

    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(person['avatar']),
        ),
        title: Text('${person['first_name']} ${person['last_name']}'),
        subtitle: Text(person['email']),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                try {
                  await apiService.deletePerson(person['id']);
                  onDelete();  
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Person deleted successfully")));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error deleting person: $e")));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
