import 'dart:io';

import 'package:dio/dio.dart';
import 'package:swapxchange/ui/home/tabs/profile/sections/settings/change_location.dart';
import 'package:swapxchange/utils/constants.dart';

// For storing our result
class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);
}

class AddressChangeMethods {
  final client = Dio();

  final apiKey = Platform.isAndroid ? Constants.ANDROID_MAP_KEY : Constants.IOS_MAP_KEY;
  //Get Search autocomplete
  Future<List<Suggestion>> fetchSuggestions({String? address}) async {
    if (address!.isEmpty) return [];

    String baseUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?';
    final request = baseUrl + 'input=$address&types=address&key=$apiKey';
    final response = await client.get(request);

    if (response.statusCode == 200) {
      final result = response.data;
      if (result['status'] == 'OK') {
        return result['predictions'].map<Suggestion>((p) => Suggestion(p['place_id'], p['description'])).toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
    } else {
      return [];
    }

    return [];
  }

  //Get Place details with even viewport coords
  Future<MapPoint?> fetchDetails({required Suggestion suggestion}) async {
    // String url = 'https://maps.googleapis.com/maps/api/place/details/json?input=${suggestion.description}&placeid=${suggestion.placeId}&key=$apiKey';
    final url = 'https://maps.googleapis.com/maps/api/geocode/json?place_id=${suggestion.placeId}&key=$apiKey';
    final response = await client.get(url);

    if (response.statusCode == 200) {
      try {
        final location = response.data["results"][0]["geometry"]["location"];
        return MapPoint(longitude: location['lng'], latitude: location['lat'], address: response.data["results"][0]["formatted_address"]);
      } catch (e) {
        print(e);
      }
    }

    return null;
  }
}
