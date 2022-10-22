import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../globals.dart';

class KrukamUrlsService {
  String? imageUrl;
  String? linkUrl;

  Future<String?> getImageUrl(String code) async {
    if (imageUrl == null) {
      await getProductLinks(code);
    }
    return imageUrl;
  }

  Future<String?> getLinkUrl(String code) async {
    if (linkUrl == null) {
      await getProductLinks(code);
    }
    return linkUrl;
  }

  Future<Map<String, String?>> getProductLinks(String code) async {
    try {
      final url = Uri.https(
        'krukam.pl',
        'search.php',
        {
          'xmlType': 'typeahead',
          'getProductXML': 'true',
          'json': 'true',
          'text': code,
          'limit': '6',
        },
      );

      final headers = {
        "Accept": "application/json",
        "Access-Control_Allow_Origin": "*",
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = convert.jsonDecode(response.body);
        imageUrl =
            "https://krukam.pl${jsonResponse['products'][0]['icon_src']}";
        linkUrl = "https://krukam.pl${jsonResponse['products'][0]['link']}";
        return {
          "imageUrl": imageUrl,
          "linkUrl": linkUrl,
        };
      } else {
        throw Exception('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      snackbarKey.currentState?.showSnackBar(
        SnackBar(
          content:
              Text("Wystąpił błąd podczas wyświetlania zdjęcia produktu.\n$e"),
        ),
      );
    }
    return {};
  }
}
