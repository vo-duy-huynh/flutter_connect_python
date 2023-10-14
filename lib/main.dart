import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Upload Image',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Upload Image'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _selectedImage;
  String? message;
  uploadImage() async {
    final request = http.MultipartRequest(
        'POST',
        Uri.parse(
            "https://bda1-2402-800-6318-9331-90c3-c372-e1c7-cdb6.ngrok.io/upload"));
    final headers = {'Content-Type': 'multipart/form-data'};
    request.files.add(http.MultipartFile('image',
        _selectedImage!.readAsBytes().asStream(), _selectedImage!.lengthSync(),
        filename: _selectedImage!.path.split('/').last));
    request.headers.addAll(headers);
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    final resJson = json.decode(res.body);
    message = resJson['message'];
    setState(() {});
  }

  Future getImage() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    _selectedImage = File(pickedImage!.path);
    setState(() {});
  }

  Future countFaces() async {
    final request = http.MultipartRequest(
        'GET',
        Uri.parse(
            "https://bda1-2402-800-6318-9331-90c3-c372-e1c7-cdb6.ngrok.io/number_faces"));
    final headers = {'Content-Type': 'multipart/form-data'};
    request.headers.addAll(headers);

    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    final resJson = json.decode(res.body);
    message = resJson['number'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _selectedImage == null
                ? Text('No image selected.')
                : Image.file(_selectedImage!),
            TextButton.icon(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: uploadImage,
                icon: Icon(Icons.upload_file, color: Colors.white),
                label: Text('Upload Image',
                    style: TextStyle(
                      color: Colors.white,
                    ))),
            TextButton.icon(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                ),
                onPressed: countFaces, // Đếm số khuôn mặt khi nhấn nút này
                icon: Icon(Icons.face, color: Colors.white),
                label: Text('Count Faces',
                    style: TextStyle(
                      color: Colors.white,
                    ))),
            Text(
              message ?? '', // Hiển thị số khuôn mặt hoặc thông báo lỗi
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
