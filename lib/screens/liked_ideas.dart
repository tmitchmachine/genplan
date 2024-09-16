import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore import
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth import

class LikedIdeasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Liked Ideas'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: user != null
            ? FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .collection('liked_ideas')
                .snapshots()
            : Stream.empty(), // Return empty stream if no user is signed in
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator()); // Loading indicator
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error fetching liked ideas.'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No liked ideas yet.'));
          }

          final likedIdeas = snapshot.data!.docs;

          return ListView.builder(
            itemCount: likedIdeas.length,
            itemBuilder: (context, index) {
              final idea = likedIdeas[index]['idea']; // Access the 'idea' field

              return ListTile(
                leading: Icon(Icons.thumb_up, color: Colors.green),
                title: Text(idea),
              );
            },
          );
        },
      ),
    );
  }
}
