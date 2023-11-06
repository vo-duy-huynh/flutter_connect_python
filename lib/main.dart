import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FaceDetectionPage(),
    );
  }
}

class FaceDetectionPage extends StatefulWidget {
  @override
  _FaceDetectionPageState createState() => _FaceDetectionPageState();
}

class _FaceDetectionPageState extends State<FaceDetectionPage> {
  Future<void> _detectFace(File image) async {
    final url =
        'https://863f-1-53-224-157.ngrok.io/detect_face'; // Đổi IP máy chủ API Python tại đây.

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(
      await http.MultipartFile.fromPath('image', image.path),
    );

    var response = await request.send();
    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      List<dynamic> results = json.decode(responseBody);
      print(results); // Xử lý và hiển thị kết quả.
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File image = File(pickedFile.path);
      // Gửi hình ảnh lên API Python và xử lý kết quả.
      _detectFace(image);
    } else {
      // Xử lý trường hợp người dùng không chọn ảnh.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Detection App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Chọn ảnh'),
            ),
          ],
        ),
      ),
    );
  }
}
