import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as pathpack;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:abu_hadid_app/classes/Socket.dart';

import 'package:abu_hadid_app/chat/chat_service.dart';
import 'package:abu_hadid_app/classes/widgets.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import 'package:image_picker/image_picker.dart';

class Chat extends StatefulWidget {
  final bool admin;
  final Socket socket;
  const Chat({
    super.key,
    required this.admin,
    required this.socket,
  });

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  late File _imageFile;
  final picker = ImagePicker();
  late String filename;

  Future pickImageCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  Future pickImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    filename = pathpack.basename(_imageFile.path);
    var firebaseStorageRef = FirebaseStorage.instance.ref().child('uploads/$filename');
    await firebaseStorageRef.putFile(_imageFile);
    _chatService.sendImageToChat(filename);
  }

  late Record recorder;
  final recordingPlayer = AssetsAudioPlayer();
  bool isRecording = false;
  String audioPath = '';
  late File audioFile;
  Directory _directory = Directory("");

  void initializer() async {
    _directory = await getApplicationDocumentsDirectory();
    audioPath = '';
    recorder = Record();
    await Permission.microphone.request();
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
  }

  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if(_messageController.text.isNotEmpty) {
      await _chatService.sendMessageToChat(_messageController.text);
      _messageController.clear();
    }
  }

  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    initializer();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> startRecording() async {
    if(!_directory.existsSync()) {
      _directory.createSync();
    }
    await recorder.start();
    setState(() {
      isRecording = true;
    });
  }

  Future<void> stopRecording() async {
    try{
//      _recordingSession.closeRecorder();
     String? path = await recorder.stop();
     setState(() {
       isRecording = false;
       audioPath = path!;
       audioFile = File(audioPath);
       print(audioPath);
     });
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(minutes: 1),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  child: Text(
                    'Dispose',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                    ),
                  ),
                ),
                _buildPlayerButton(),
                TextButton(
                  onPressed: () {
                    uploadAudioToFirebase(context);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    widget.socket.SendNotifi("Abu Hadid sent voice to chat!");
                  },
                  child: Text(
                      'Send',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ));
    }catch (e){
      print('Error Stopping record : $e');
    }
  }

  Future<void> stopRecordingPublic() async {
    try{
//      _recordingSession.closeRecorder();
      String? path = await recorder.stop();
      setState(() {
        isRecording = false;
        audioPath = path!;
        audioFile = File(audioPath);
        print(audioPath);
      });
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(minutes: 1),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  child: Text(
                    'Dispose',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                    ),
                  ),
                ),
                _buildPlayerButton(),
                TextButton(
                  onPressed: () async {
                    final DocumentReference document = FirebaseFirestore.instance.collection("Admins").doc('admins');
                    late dynamic data;
                    data = await document.get();
                    if (data['AdminCheck']) {
                      FocusScope.of(context).unfocus();
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You have no permission')));
                    }
                    else {
                      uploadAudioToFirebase(context);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    }
                  },
                  child: Text(
                    'Send',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ));
    }catch (e){
      print('Error Stopping record : $e');
    }
  }

  Future uploadAudioToFirebase(BuildContext context) async {
    filename = pathpack.basename(audioPath);
    var firebaseStorageRef = FirebaseStorage.instance.ref().child('uploadsAudio/$filename');
    await firebaseStorageRef.putFile(audioFile);
    _chatService.sendVoiceToChat(filename);
  }

  Widget _buildAllChatButton(bool admin) {
    if (admin) {
      return TextButton(
        child: Text(
            'Alternate Chat',
            style: TextStyle(
              color: Colors.green,
              fontSize: 10,
              fontFamily: 'Oswald',
            )
        ),
          onPressed: () async {
            final DocumentReference document = FirebaseFirestore.instance.collection("Admins").doc('admins');
            late dynamic data;
            data = await document.get();
            if (data['AdminCheck']) {
              await FirebaseFirestore.instance.collection("Admins").doc('admins').update({'AdminCheck': false});
              FocusScope.of(context).unfocus();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Everybody is now able to text.')));
            }
            else {
              await FirebaseFirestore.instance.collection("Admins").doc('admins').update({'AdminCheck': true});
              FocusScope.of(context).unfocus();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Nobody, except admins, is now able to text.')));
            }
          }
          );
    }
    else return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        shadowColor: Colors.white,
        backgroundColor: Colors.amber[200],
        title: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.chat,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                    Text(
                        'Chat Room',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontFamily: 'Oswald',
                        )
                    ),
                  ],
                ),
              ),
            ),
            _buildAllChatButton(widget.admin)
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: _buildMessageList(),
          ),

          _buildMessageInput(widget.admin),
          SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(stream: _chatService.getMessagesFromChat(), builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text(
            'Error${snapshot.error}',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
        )
        );
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: const SpinKitPouringHourGlass(color: Colors.green)
        );
      }

      return ListView(
        children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
      );
    }
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    bool isLiked = false;
    isLiked = data['likes'].contains(currentUser.uid);

    if (data['audioname'] == '' && data['imagename'] == '') {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Card(
            color: Colors.amber[200],
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                  child: Center(
                    child: Text(
                      data['senderUid'],
                      style: TextStyle(
                        fontFamily: 'Oswald',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      data['message'],
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          if (widget.admin) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    TextButton(
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                        },
                                        child: Text(
                                            'Cancel'
                                        )
                                    ),

                                    TextButton(
                                        onPressed: () {
                                          FirebaseFirestore.instance.collection('signal_room').doc('chat_room').collection('messages').doc(document.id).delete();
                                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                        },
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(
                                              color: Colors.red
                                          ),
                                        )
                                    ),
                                  ],
                                )
                                )
                            );
                          }else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('You have no permission'))
                            );
                          };
                        },
                        icon: Icon(
                          Icons.delete,
                        )
                    ),


                    Row(
                      children: [
                        Text(
                          data['likes'].length.toString(),
                        ),
                        Padding(
                            padding: EdgeInsets.all(5),
                            child: LikeButton(isLiked: isLiked, onTap: () {
                              setState(() {
                                isLiked = !isLiked;
                                DocumentReference messageRef = FirebaseFirestore.instance.collection('signal_room').doc('chat_room').collection('messages').doc(document.id);

                                if (isLiked) {
                                  messageRef.update({
                                    'likes': FieldValue.arrayUnion([currentUser.uid])
                                  });
                                } else {
                                  messageRef.update({
                                    'likes': FieldValue.arrayRemove([currentUser.uid])
                                  });
                                }
                              });
                            })
                        ),
                      ],
                    )
                  ],
                )
              ],
            )
        ),
      );
    }
    if (data['imagename'] == '' && data['message'] == '') {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Card(
            color: Colors.amber[200],
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                  child: Center(
                    child: Text(
                      data['senderUid'],
                      style: TextStyle(
                        fontFamily: 'Oswald',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: FutureBuilder(
                      future: _getAudio(context, data),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done)
                          return Container(
                              child: _buildAudioData(snapshot.data!)
                          );
                        else return Container(child: SpinKitPouringHourGlass(color: Colors.green),);
                      }
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          if (widget.admin) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    TextButton(
                                        onPressed: () {
                                         ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                        },
                                        child: Text(
                                            'Cancel'
                                       )
                                    ),

                                   TextButton(
                                       onPressed: () {
                                          FirebaseFirestore.instance.collection('signal_room').doc('chat_room').collection('messages').doc(document.id).delete();
                                         ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                        },
                                        child: Text(
                                         'Delete',
                                          style: TextStyle(
                                              color: Colors.red
                                          ),
                                        )
                                   ),
                                 ],
                                )
                                )
                              );
                            }else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('You have no permission'))
                            );
                          };
                          },
                        icon: Icon(
                          Icons.delete,
                        )
                    ),
                    Row(
                      children: [
                        Text(
                          data['likes'].length.toString(),
                        ),
                        Padding(
                            padding: EdgeInsets.all(5),
                            child: LikeButton(isLiked: isLiked, onTap: () {
                              setState(() {
                                isLiked = !isLiked;
                                DocumentReference messageRef = FirebaseFirestore.instance.collection('signal_room').doc('chat_room').collection('messages').doc(document.id);

                                if (isLiked) {
                                  messageRef.update({
                                    'likes': FieldValue.arrayUnion([currentUser.uid])
                                  });
                                } else {
                                  messageRef.update({
                                    'likes': FieldValue.arrayRemove([currentUser.uid])
                                  });
                                }
                              });
                            })
                        ),
                      ],
                    )
                  ],
                )
              ],
            )
        ),
      );
    }
    if (data['audioname'] == '' && data['message'] == '') {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Card(
            color: Colors.amber[200],
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                  child: Center(
                    child: Text(
                      data['senderUid'],
                      style: TextStyle(
                        fontFamily: 'Oswald',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: FutureBuilder(
                        future: _getImage(context, data),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done)
                            return Container(
                                child: _buildImageData(snapshot.data!)
                            );
                          else return Container(child: SpinKitPouringHourGlass(color: Colors.green),);
                        }
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          if (widget.admin) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    TextButton(
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                        },
                                        child: Text(
                                            'Cancel'
                                        )
                                    ),

                                    TextButton(
                                        onPressed: () {
                                          FirebaseFirestore.instance.collection('signal_room').doc('chat_room').collection('messages').doc(document.id).delete();
                                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                        },
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(
                                              color: Colors.red
                                          ),
                                        )
                                    ),
                                  ],
                                )
                                )
                            );
                          }else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('You have no permission'))
                            );
                          };
                        },
                        icon: Icon(
                          Icons.delete,
                        )
                    ),
                    Row(
                      children: [
                        Text(
                          data['likes'].length.toString(),
                        ),
                        Padding(
                            padding: EdgeInsets.all(5),
                            child: LikeButton(isLiked: isLiked, onTap: () {
                              setState(() {
                                isLiked = !isLiked;
                                DocumentReference messageRef = FirebaseFirestore.instance.collection('signal_room').doc('chat_room').collection('messages').doc(document.id);

                                if (isLiked) {
                                  messageRef.update({
                                    'likes': FieldValue.arrayUnion([currentUser.uid])
                                  });
                                } else {
                                  messageRef.update({
                                    'likes': FieldValue.arrayRemove([currentUser.uid])
                                  });
                                }
                              });
                            })
                        ),
                      ],
                    )
                  ],
                )
              ],
            )
        ),
      );
    } else return Card(child: Text('Error'), color: Colors.amber[200]);
  }

  Widget _buildMessageInput(bool admin) {
      if (admin) {
        return Row(
          children: [
            Expanded(
                child: EnterTextField(
                    'Text',
                    Icons.message,
                    false,
                    _messageController
                )
            ),
            _buildRecorderButton(),
            _buildSelectImageButton(context),
            IconButton(
                onPressed: () {
                  sendMessage();
                  widget.socket.SendNotifi("Abu Hadid sent message to chat!");
                },
                icon: Icon(
                  Icons.send,
                  color: Colors.amber[200],
                )
            )
          ],
        );
      } else {
        return Row(
          children: [
            Expanded(
                child: EnterTextField(
                    'Text',
                    Icons.message,
                    false,
                    _messageController
                )
            ),
            _buildRecorderButtonPublic(),
            _buildSelectImageButtonPublic(context),
            IconButton(
                onPressed: () async {
                  final DocumentReference document = FirebaseFirestore.instance.collection("Admins").doc('admins');
                  late dynamic data;
                  data = await document.get();
                  if (data['AdminCheck']) {
                    FocusScope.of(context).unfocus();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You have no permission')));
                  }
                  else {
                    sendMessage();
                  }
                },
                icon: Icon(
                  Icons.send,
                  color: Colors.white,
                )
            )
          ],
        );
      }
  }

  Widget _buildRecorderButton() {
    final icon = isRecording ? Icons.mic : Icons.mic_none;
    final color = isRecording ? Colors.red : Colors.amber[200];

    return IconButton(
        onPressed: isRecording ? stopRecording : startRecording,
        icon: Icon(
            icon,
        color: color,)
    );
  }

  Widget _buildRecorderButtonPublic() {
    final icon = isRecording ? Icons.mic : Icons.mic_none;
    final color = isRecording ? Colors.red : Colors.white;

    return IconButton(
        onPressed: isRecording ? stopRecordingPublic : startRecording,
        icon: Icon(
          icon,
          color: color,)
    );
  }

  Widget _buildPlayerButton() {
    bool isPlaying = false;

    return TextButton(
      onPressed: () async {
        try{
          if (!isRecording && audioPath != null) {
            recordingPlayer.open(
                Audio.file(audioPath),
              autoStart: true,
              showNotification: true,
            );
          }
        }catch (e){
          print('Error Playing Record : $e');
        }
      },
      child: Text(
        'Read',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSelectImageButton(BuildContext context) {
    return IconButton(
        onPressed: () async {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: () async {
                        widget.socket.SendNotifi("Abu Hadid sent image to chat!");
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        await pickImageCamera();
                        uploadImageToFirebase(context);
                      },
                      icon: Icon(
                        Icons.camera_alt,
                        color: Colors.amber[200],
                      )
                  ),
                  IconButton(
                      onPressed: () async {
                        widget.socket.SendNotifi("Abu Hadid sent image to chat!");
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        await pickImageGallery();
                        uploadImageToFirebase(context);
                      },
                      icon: Icon(
                        Icons.image,
                          color: Colors.amber[200],
                      )
                  ),
                ],
              )
          ));
        },
        icon: Icon(
          Icons.add_a_photo_outlined,
          color: Colors.amber[200],
        )
    );
  }

  Widget _buildSelectImageButtonPublic(BuildContext context) {
    return IconButton(
        onPressed: () async {
          final DocumentReference document = FirebaseFirestore.instance.collection("Admins").doc('admins');
          late dynamic data;
          data = await document.get();
          if (data['AdminCheck']) {
            FocusScope.of(context).unfocus();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You have no permission')));
          }
          else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        onPressed: () async {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          await pickImageCamera();
                          uploadImageToFirebase(context);
                        },
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        )
                    ),
                    IconButton(
                        onPressed: () async {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          await pickImageGallery();
                          uploadImageToFirebase(context);
                        },
                        icon: Icon(
                          Icons.image,
                          color: Colors.white,
                        )
                    ),
                  ],
                )
            ));
          }
        },
        icon: Icon(
          Icons.add_a_photo_outlined,
          color: Colors.white,
        )
    );
  }

  Future<String> _getImage(BuildContext context, Map<String, dynamic> data) async {
    if(data['imagename'] != null) {
      final ref = FirebaseStorage.instance.ref().child(
          'uploads/${data['imagename']}');
      var url = await ref.getDownloadURL();
      return url;
    }
    else {
      return 'null';
    }
  }

  Future<String> _getAudio(BuildContext context, Map<String, dynamic> data) async {
    if(data['audioname'] != null) {
      final ref = FirebaseStorage.instance.ref().child(
          'uploadsAudio/${data['audioname']}');
      var url = await ref.getDownloadURL();
      return url;
    }
    else {
      return 'null';
    }
  }

  Widget _buildImageData(String data) {
    if (data == 'null') {
      return SpinKitPouringHourGlass(color: Colors.green);
    }
    else return Image(
      image: NetworkImage(data),
    );
  }

  Widget _buildAudioData(String data) {
    if (data == 'null') {
      return SpinKitPouringHourGlass(color: Colors.green);
    }
    else return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
            'Voice Message',
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 20
          ),
        ),
        SizedBox(
          height: 10,
        ),
        IconButton(
            onPressed: () async {
              try{
                if (!isRecording && data != null) {
                  recordingPlayer.open(
                    Audio.network(data),
                    autoStart: true,
                    showNotification: true,
                  );
                }
              }catch (e){
                print('Error Playing Record : $e');
              }
            },
            icon: Icon(
              Icons.play_circle_outline,
              color: Colors.grey[900],
              size: 35,
            )
        ),
      ],
    );
  }
}
