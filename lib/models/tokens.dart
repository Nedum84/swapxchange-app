import 'dart:convert';

class Tokens {
  Tokens({
    this.access,
    this.refresh,
  });

  final Token? access;
  final Token? refresh;

  factory Tokens.fromJson(String str) => Tokens.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Tokens.fromMap(Map<String, dynamic> json) => Tokens(
        access: Token.fromMap(json["access"]),
        refresh: Token.fromMap(json["refresh"]),
      );

  Map<String, dynamic> toMap() => {
        "access": access?.toMap(),
        "refresh": refresh?.toMap(),
      };
}

class Token {
  Token({
    required this.token,
    required this.expires,
  });

  final String token;
  final DateTime expires;

  factory Token.fromJson(String str) => Token.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Token.fromMap(Map<String, dynamic> json) => Token(
        token: json["token"],
        expires: DateTime.parse(json["expires"]),
      );

  Map<String, dynamic> toMap() => {
        "token": token,
        "expires": expires.toIso8601String(),
      };
}
