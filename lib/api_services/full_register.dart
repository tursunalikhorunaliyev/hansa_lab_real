import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BlocSignUp {
  Future<bool> signUp(
      lastname,
      firstname,
      email,
      bornedAt,
      jobId,
      storeid,
      shopnet,
      shopadress,
      phone,
      countrytype,
      cityid,
      isAgreeSms,
      isAgreeIdentity,
      isAgreePersonal) async {
    Map body = {
      "lastname": lastname,
      "firstname": firstname,
      "email": email,
      "borned_at": bornedAt,
      "job_id": jobId,
      "store_id": storeid,
      "shop_net": shopnet,
      "shop_address": shopadress,
      "phone": phone,
      "country_type": countrytype,
      "city_id": cityid,
      "isAgreeSms": isAgreeSms,
      "isAgreeIdentity": isAgreeIdentity,
      "isAgreePersonal": isAgreePersonal
    };
    http.Response response = await http.post(
      Uri.parse("http://hansa-lab.ru/api/auth/signup"),
      body: body,
    );
    return jsonDecode(response.body)["status"] as bool;
  }
}