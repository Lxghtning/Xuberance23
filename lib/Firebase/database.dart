import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



class Database {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(name, email, uid, token) {
    return _firestore.collection('users')
        .doc(uid).set({
      'name': name,
      'email': email,
      'uid': uid,
      'friendsIDList': [],
      'friendsNameList': [],
      'friendRequestsIDList': [],
      'friendRequestsNameList': [],
      'messages': [],
      'messagesFrom': [],
      'messagesTo': [],
      'messagesBoolean': [],
      'feed': [],
      'feedID':[],
      'feedBoolean':[],
      'token': token,
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future checkForUserRegister(String email) async {
    bool returnValue = false;
    await _firestore.collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['email'] == email) {
          returnValue = true;
        }
      }
    });
    return returnValue;
  }


  Future<List> sendUsers() async {
    List<String> userList = [];
    await _firestore.collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['uid'] == _auth.currentUser?.uid) {
          //same user
        }
        else {
          userList.insert(0, doc['name']);
        }
      }
    });

    return userList;
  }

  Future friendRequestFunction(String name) async {
    String nameOfFriend = await friendName(_auth.currentUser!.uid);
    await _firestore.collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['name'] == name) {
          List friendReqList = doc['friendRequestsIDList'];
          List friendReqNameList = doc['friendRequestsNameList'];
          bool containsUser = friendReqList.any((element) =>
          element == _auth.currentUser?.uid);
          if (!containsUser) {
            friendReqNameList.insert(0, nameOfFriend);
            friendReqList.insert(0, _auth.currentUser?.uid);
            doc.reference.update({
              'friendRequestsIDList': friendReqList,
              'friendRequestsNameList': friendReqNameList,
            });
          }
        }
      }
    });
  }


  Future<List> sendFriendRequestNameList() async {
    List friendReqNameList = [];

    await _firestore.collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['uid'] == _auth.currentUser?.uid) {
          friendReqNameList = doc['friendRequestsNameList'];
        }
      }
    });

    return friendReqNameList;
  }

  Future removeFriendFriend(String name) async {
    String nameOfFriend = await friendName(_auth.currentUser!.uid);
    String id = await friendID(name);
    await _firestore.collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['uid'] == id) {
          List friendsIDList = doc['friendsIDList'];
          List friendsNameList = doc['friendRequestsNameList'];
          bool containsUser = friendsIDList.any((element) =>
          element == _auth.currentUser?.uid);
          if (containsUser) {
            friendsNameList.remove(nameOfFriend);
            friendsIDList.remove(_auth.currentUser?.uid);
            doc.reference.update({
              'friendsIDList': friendsIDList,
              'friendsNameList': friendsNameList,
            });
          }
        }
      }
    });
  }

  Future removeFriendCurrentUser(String name) async {
    String id = await friendID(name);
    await _firestore.collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['uid'] == _auth.currentUser?.uid) {
          List friendsIDList = doc['friendsIDList'];
          List friendsNameList = doc['friendRequestsNameList'];
          bool containsUser = friendsIDList.any((element) =>
          element == id);
          if (containsUser) {
            friendsNameList.remove(name);
            friendsIDList.remove(id);
            doc.reference.update({
              'friendsIDList': friendsIDList,
              'friendsNameList': friendsNameList,
            });
          }
        }
      }
    });
  }


  Future addRequestedUserToCurrentUserFriendList(nameOfFriend) async {
    List friendsIDList = [];
    List friendsNameList = [];
    String nameCurrentUser = await friendName(_auth.currentUser!.uid);
    String idOfFriend = await friendID(nameOfFriend);

    await _firestore.collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['uid'] == idOfFriend) {
          friendsIDList = doc['friendsIDList'];
          friendsNameList = doc['friendsNameList'];
          bool containsFriend = friendsIDList.any((element) =>
          element == _auth.currentUser?.uid);
          if (!containsFriend) {
            friendsIDList.insert(0, _auth.currentUser?.uid);
            friendsNameList.insert(0, nameCurrentUser);
            doc.reference.update({
              'friendsIDList': friendsIDList,
              'friendsNameList': friendsNameList,
            });
          }
        }
      }
    });
  }

  Future addUserToFriendList(String nameOfFriend) async {
    List friendList = [];
    List friendNameList = [];
    String id = await friendID(nameOfFriend);

    await _firestore.collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['uid'] == _auth.currentUser?.uid) {
          friendList = doc['friendsIDList'];
          friendNameList = doc['friendsNameList'];
          bool containsFriend = friendList.any((element) => element == id);
          if (!containsFriend) {
            friendList.insert(0, id);
            friendNameList.insert(0, nameOfFriend);
            doc.reference.update({
              'friendsIDList': friendList,
              'friendsNameList': friendNameList,
            });
          }
        }
      }
    });
  }


  Future popFriendReqList(String nameOfFriend) async {
    List friendIDList = [];
    List friendNameList = [];
    String id = await friendID(nameOfFriend);
    await _firestore.collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['uid'] == _auth.currentUser?.uid) {
          friendIDList = doc['friendRequestsIDList'];
          friendNameList = doc['friendRequestsNameList'];
          friendIDList.remove(id);
          friendNameList.remove(nameOfFriend);
          doc.reference.update({
            'friendRequestsIDList': friendIDList,
            'friendRequestsNameList': friendNameList,
          });
        }
      }
    });
  }

  Future<List> sendFriendsNameList() async {
    List friendsNameList = [];
    await _firestore.collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['uid'] == _auth.currentUser?.uid) {
          friendsNameList = doc['friendsNameList'];
        }
      }
    });

    return friendsNameList;
  }

  Future<List> sendFriendsIDList() async {
    List friendsIDList = [];
    await _firestore.collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['uid'] == _auth.currentUser?.uid) {
          friendsIDList = doc['friendsIDList'];
        }
      }
    });

    return friendsIDList;
  }


  Future checkIfUser(String name) async {
    bool returnValue = false;
    await _firestore.collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['name'] == name) {
          returnValue = true;
        }
      }
    });
    return returnValue;
  }

  Future currentUserName() async {
    String name = '';
    await _firestore.collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['uid'] == _auth.currentUser?.uid) {
          name = doc['name'];
        }
      }
    });
    return name;
  }

  Future checkForFriendCurrentUser(String name) async {
    bool friendState = false;
    String id = await friendID(name);
    List friendListCurrentUser = [];

    await _firestore.collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['uid'] == _auth.currentUser?.uid) {
          friendListCurrentUser = doc['friendsIDList'];
          bool currentUserIsFriend = friendListCurrentUser.any((
              element) => element == id);
          if (currentUserIsFriend) {
            friendState = true;
          }
        }
      }
    });
    return friendState;
  }

  Future checkForFriendSendingUser(String name) async {
    bool friendState = false;
    String id = await friendID(name);
    List friendListSendingUser = [];

    await _firestore.collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['uid'] == id) {
          friendListSendingUser = doc['friendsIDList'];
          bool sendingUserIsFriend = friendListSendingUser.any((
              element) => element == _auth.currentUser?.uid);
          if (sendingUserIsFriend) {
            friendState = true;
          }
        }
      }
    });
    return friendState;
  }

  Future sendMessageCurrentUser(String name, String message) async {
    List messages = [];
    List messagesTo = [];
    List messagesBoolean = [];

    await _firestore.collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['uid'] == _auth.currentUser?.uid) {
          messages = doc['messages'];
          messagesTo = doc['messagesTo'];
          messagesBoolean = doc['messagesBoolean'];
          messages.add(message);
          messagesTo.add(name);
          messagesBoolean.add(true);
          doc.reference.update({
            'messages': messages,
            'messagesTo': messagesTo,
            'messagesBoolean': messagesBoolean,
          });
        }
      }
    });
  }


  Future sendMessageToFriend(String name, String message) async {
    List messagesFrom = [];
    List messages = [];
    List messagesBoolean = [];

    String id = await friendID(name);
    String currentUserName = await friendName(_auth.currentUser!.uid);

    await _firestore.collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['uid'] == id) {
          messagesFrom = doc['messagesFrom'];
          messages = doc['messages'];
          messagesBoolean = doc['messagesBoolean'];
          messages.add(message);
          messagesFrom.add(currentUserName);
          messagesBoolean.add(false);
          doc.reference.update({
            'messagesFrom': messagesFrom,
            'messages': messages,
            'messagesBoolean': messagesBoolean,
          });
        }
      }
    });
  }

  Future messagesListSend(name) async {
    List messagesSent = [];
    List messagesTo = [];

    await _firestore.collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['uid'] == _auth.currentUser?.uid) {
          messagesSent = doc['messages'];
          messagesTo = doc['messagesTo'];
          for(int i = 0; i<messagesTo.length; i++){
            if(messagesTo[i] != name){
              messagesTo.remove(messagesTo[i]);
            }
          }
        }
      }
    });

    return messagesSent;
  }



  Future sendCurrentUserDetails() async {
    Map<String, dynamic> currentUserDetails = {};
    await _firestore.collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['uid'] == _auth.currentUser?.uid) {
          List temp = doc['friendsIDList'];
          currentUserDetails['name'] = doc['name'];
          currentUserDetails['email'] = doc['email'];
          currentUserDetails['friendCount'] = temp.length;
        }
      }
    });

    return currentUserDetails;
  }

  Future addFeed(String post, bool isPic) async{
    List friendsIDList = await sendFriendsIDList();
    int i=0;
    await _firestore.collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        try {
          if (doc['uid'] == friendsIDList[i]) {
            List feedList = doc['feed'];
            List feedID = doc['feedID'];
            List feedPic = doc['feedBoolean'];
            if(isPic){
              feedPic.add(true);
              doc.reference.update({
                'feedBoolean': feedPic,
              });
            }
            else{
              feedPic.add(false);
              doc.reference.update({
                'feedBoolean': feedPic,
              });
            }
            feedList.insert(0, post);
            feedID.insert(0, _auth.currentUser?.uid);
            doc.reference.update({
              'feed': feedList,
              'feedID': feedID,
            });
            i++;
          }
        }
        catch(e){
          //error
        }

        if (doc['uid'] == _auth.currentUser?.uid) {
          List feedList = doc['feed'];
          List feedID = doc['feedID'];
          List feedBoolean = doc['feedBoolean'];
          feedList.insert(0, post);
          feedID.insert(0, _auth.currentUser?.uid);
          feedBoolean.insert(0, isPic);
          doc.reference.update({
            'feed': feedList,
            'feedID': feedID,
            'feedBoolean': feedBoolean,
          });
        }
      }
    });
  }

  Future feedName() async {
    List FeedName = [];
    await _firestore.collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        if (doc['uid'] == _auth.currentUser?.uid) {
          List fn = doc['feedID'];
          for(int i =0; i<fn.length; i++){
            String name = await friendName(fn[i]);
            FeedName.add(name);
          }
        }
      }
    });
    return FeedName;
  }

  Future feedPost() async {
    List FeedPost = [];
    await _firestore.collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['uid'] == _auth.currentUser?.uid) {
          FeedPost = doc['feed'];
        }
      }
    });
    return FeedPost;
  }


  Future friendName(String id) async {
    String name = '';
    await _firestore.collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['uid'] == id) {
          name = doc['name'];
        }
      }
    });
    return name;
  }

  Future friendID(String nameOfFriend) async {
    String id = '';
    await _firestore.collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['name'] == nameOfFriend) {
          id = doc['uid'];
        }
      }
    });
    return id;
  }

  Future sendMessagesBooleanList() async {
    List messagesBoolean = [];
    await _firestore.collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['uid'] == _auth.currentUser?.uid) {
          messagesBoolean = doc['messagesBoolean'];
        }
      }
    });
    return messagesBoolean;
  }


  Future sendFeedBooleanList() async {
    List feedBoolean = [];
    await _firestore.collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['uid'] == _auth.currentUser?.uid) {
          feedBoolean = doc['feedBoolean'];
        }
      }
    });
    return feedBoolean;
  }


}