

import 'dart:convert';

import '../model/Place.dart';
import 'package:http/http.dart' as http;

Future<List<Place>> fetchPlaces() async {
  final response = await http.get(Uri.parse('https://65118211829fa0248e403ace.mockapi.io/api/v1/place'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);

    // Parse the JSON data and create a list of Place objects
    List<Place> places = data.map((json) {
      return Place(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        imageUrl: json['image_url'],
      );
    }).toList();

    return places;
  } else {
    throw Exception('Failed to load places');
  }
}
