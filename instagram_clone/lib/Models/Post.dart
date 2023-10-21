import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  final String Description;
  final  datePublished;
  final String uid;
  final String postId;
  final String username;
  final String PostUrl;
  final String ProfImage;
  final likes;
  const Post({
    required this.Description,
    required this.postId,
    required this.uid,
    required this.username,
    required this.datePublished,
    required this.likes,
    required this.PostUrl,
    required this.ProfImage
  });
  Map<String,dynamic>toJson()=>{
    "username":username,
    "postid":postId,
    "uid":uid,
    "bio":PostUrl,
    "Description":Description,
    "PostUrl":PostUrl,
    "ProfImage":ProfImage,
    "likes":likes,
    "datePublished":datePublished,
  };
  static Post userFromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String,dynamic>;
    print(snap);
    return Post(
        datePublished: snapshot["datePublished"],
        likes: snapshot['likes'],
        Description: snapshot['Description'],
        postId : snapshot['postId'],
        PostUrl: snapshot['PostUrl'],
        ProfImage: snapshot['ProfImage'],
        uid: snapshot['uid'],
        username: snapshot['username']
    );
  }
}