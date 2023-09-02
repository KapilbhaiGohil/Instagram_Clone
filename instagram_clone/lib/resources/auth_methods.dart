import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //sign up the user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  })async
  {
    String res = "Some Error Occured";
    try{
      if(email.isNotEmpty || password.isNotEmpty || username.isNotEmpty || bio.isNotEmpty || file!= null){
        //register the user
        UserCredential cred= await _auth.createUserWithEmailAndPassword(email: email, password: password);

        //add user to our database
        //if user exists then override the data
        await _firestore.collection('users').doc(cred.user!.uid).set({
          'username':username,
          'uid':cred.user!.uid,
          'bio':bio,
          'email':email,
          'followers':[],
          'following':[],
          // 'file':
        });
        res = "Sucess";
      }
    }catch(e){
      res = e.toString();
    }
    return res;
  }
}