import 'dart:io';
import 'package:flutter_football/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final String matchResourcesBucketName = "match-resources";

Future<String> uploadImage(File imageFile, String bucketName, String path) async {
  final response = await supabase.storage
      .from(bucketName)
      .upload(path, imageFile);
  print(response);
  return response;
}

Future<void> downloadImage(String filePath, String bucketName) async {
  final response = await supabase.storage
      .from(bucketName)
      .download(filePath);
  print(response);
}

Future<void> createBucket(String bucketName) async {
  final response = await supabase.storage.createBucket(bucketName);
  print(response);
}

Future<List<FileObject>> listFilesInBucket(String bucketName) async {
  final response = await supabase.storage
      .from(bucketName)
      .list();
  return response;
}

String createFileName() {
  return "${DateTime.now().millisecondsSinceEpoch}.jpg";
}