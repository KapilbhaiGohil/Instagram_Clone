import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone/Models/Post.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String>UploadPost(
      String Description,
      Uint8List file,
      String uid,
      String username,
      String ProfileImage,
      )async{
    String res = "some error occured";
    try{
      String photoUrl = await StorageMethods().UploadImageToStorage("Post", file, true);
      String postid = Uuid().v1();
      Post post = Post(
          Description: Description,
          uid: uid,
          username: username,
          postId: postid,
          datePublished: DateTime.now(),
          PostUrl: photoUrl,
          ProfImage: ProfileImage,
          likes: []
      );
      await _firestore.collection('Post').doc(postid).set(post.toJson());
      res = "success";
    }catch(err){
        res = err.toString();
    }
    return res;
  }
  Future<void>likePost(String postid,String uid,List likes)async{
    try{
      if(likes.contains(uid)){
       await  _firestore.collection('Post').doc(postid).update(
          {'likes':FieldValue.arrayRemove([uid])}
        );
      }else{
        await _firestore.collection('Post').doc(postid).update(
            {'likes':FieldValue.arrayUnion([uid])}
        );
      }
    }catch(err){
      print(err.toString());
    }
  }
  Future<void>postComment(String postid,String text,String uid,String name,String profilePic)async{
    try{
      if(text.isNotEmpty){
        String commentId = const Uuid().v1();
        await _firestore.collection('Post').doc(postid).collection('comment').doc(commentId).set({
          "profilePic":profilePic,
          "name":name,
          "uid":uid,
          "text":text,
          "commentId":commentId,
          "datePublished":DateTime.now()
        });
      }else{
        print('text is empty');
      }
    }catch(err){
      print(err.toString());
    }
  }
  Future<void>deletePost(String postid)async{
    try{
      await _firestore.collection('Post').doc(postid).delete();
    }catch(err){
      print(err.toString());
    }
  }
  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
      await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
  }
}