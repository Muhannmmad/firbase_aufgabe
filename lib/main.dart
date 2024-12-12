import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Hobbies(),
    );
  }
}

class Hobbies extends StatelessWidget {
  const Hobbies({Key? key}) : super(key: key);

  Future<List<Map<String, dynamic>>> fetchHobbies() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collectionGroup('Hobbies').get();

    return querySnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchHobbies(),
        builder: (context, snapshot) {
          final hobbies = snapshot.data ?? [];
          return ListView.builder(
            itemCount: hobbies.length,
            itemBuilder: (context, index) {
              final hobby = hobbies[index];
              return ListTile(
                title: Text(hobby['name']),
                subtitle: Text(
                  'Type: ${hobby['type']}, Members: ${hobby['members']}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
