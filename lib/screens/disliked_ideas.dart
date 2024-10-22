import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DislikedIdeasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Disliked Ideas'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: user != null
            ? FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .collection('disliked_ideas')
                .orderBy('timestamp', descending: true)
                .snapshots()
            : Stream.empty(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error fetching disliked ideas.'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No disliked ideas yet.'));
          }

          final dislikedIdeas = snapshot.data!.docs;

          return ListView.builder(
            itemCount: dislikedIdeas.length,
            itemBuilder: (context, index) {
              final idea = dislikedIdeas[index]['idea'];

              return ListTile(
                leading: Icon(Icons.thumb_down, color: Colors.red),
                title: Text(idea),
              );
            },
          );
        },
      ),
    );
  }
}
