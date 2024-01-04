import 'package:caroby/caroby.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:tamirci/core/firebase/f_auth.dart';
import 'package:tamirci/core/models/m_customer.dart';
import 'package:tamirci/core/models/m_service.dart';
import 'package:tamirci/core/models/m_vehicle.dart';

enum FirestoreCol {
  shops,
  customers,
  services,
  vehicles,
  stats,
}

final class FirestoreSub {
  final FirestoreCol col;
  final String? doc;

  FirestoreSub({required this.col, this.doc});
}

class FirestoreResponse<T> {
  final T? response;
  final FirebaseException? exception;
  final String? docID;
  final Timestamp? lastDate;

  FirestoreResponse({this.response, this.exception, this.docID, this.lastDate});

  bool get hasError {
    return exception != null ? true : false;
  }
}

final class FFirestore {
  const FFirestore._();

  static int _functionCount = 0;

  static final _instance = FirebaseFirestore.instance;

  static final _shopInstance =
      _instance.collection(FirestoreCol.shops.name).doc(FAuth.uid);

  static final _customerInstance =
      _shopInstance.collection(FirestoreCol.customers.name);

  static final _vehicleInstance =
      _shopInstance.collection(FirestoreCol.vehicles.name);

  static final List<MCustomer> _customers = [];

  static FirebaseException _firebaseException(dynamic exception) {
    if (exception is FirebaseException) {
      return exception;
    } else if (exception is Object) {
      return FirebaseException(
          plugin: "", code: "error", message: exception.toString());
    }

    return FirebaseException(plugin: "", code: "error", message: "error");
  }

  static Future<FirestoreResponse<T>> _function<T>(Future function) async {
    if (_functionCount >= 5000) {
      return FirestoreResponse(
          exception: FirebaseException(
              plugin: "error",
              code: "limit",
              message: "Reached function limit"));
    }
    _functionCount++;

    try {
      T result = await function;

      return FirestoreResponse<T>(response: result);
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e.code);
      }
      return FirestoreResponse(exception: _firebaseException(e));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return FirestoreResponse(exception: _firebaseException(e));
    }
  }

  static Future<FirestoreResponse> delete(
    FirestoreCol col,
    String doc, {
    FirestoreCol? col2,
  }) async {
    dynamic ref = _instance.collection(col.name).doc(doc);

    if (col2 != null) {
      ref = ref.collection(col.name);
    }

    final fun = ref.delete();

    final r = await _function(fun);

    if (r.hasError) {
      return r;
    }

    return FirestoreResponse(response: true);
  }

  static Future<FirestoreResponse<DocumentSnapshot<Map<String, dynamic>>>> get(
    FirestoreCol col, {
    String? doc,
    List<FirestoreSub>? subs,
  }) async {
    var ref = _instance.collection(col.name).doc(doc);

    subs ??= [];

    for (var sub in subs) {
      if (sub.doc.isNotEmptyAndNull) {
        ref = ref.collection(sub.col.name).doc(sub.doc);
      }
    }

    final fun = ref.get();

    final r = await _function<DocumentSnapshot<Map<String, dynamic>>>(fun);
    return r;
  }

  static Future<FirestoreResponse<bool>> update(
    FirestoreCol col,
    String doc,
    Map<String, dynamic> map, {
    List<FirestoreSub>? subs,
  }) async {
    var ref = _instance.collection(col.name).doc(doc);

    subs ??= [];

    for (var sub in subs) {
      if (sub.doc.isNotEmptyAndNull) {
        ref = ref.collection(sub.col.name).doc(sub.doc);
      } else {
        return FirestoreResponse(
          exception: FirebaseException(
              plugin: "error",
              code: "wrong-update-path",
              message: "Update doc can't be null!"),
        );
      }
    }

    final fun = ref.update(map);

    var r = await _function(fun);

    if (r.hasError && r.exception!.code == "not-found") {
      final fun2 = _instance.collection(col.name).doc(doc).set(map);
      r = await _function(fun2);
    }

    if (r.hasError) {
      return FirestoreResponse(exception: r.exception);
    }

    return FirestoreResponse(response: true);
  }

  static Future<FirestoreResponse<bool>> set(
    FirestoreCol col, {
    String? doc,
    Map<String, dynamic>? map,
    List<FirestoreSub>? subs,
  }) async {
    if (map == null) {
      return FirestoreResponse(
          exception: FirebaseException(
              plugin: "p", code: "no-map", message: "No map passed!"));
    }

    var ref = _instance.collection(col.name).doc(doc);

    subs ??= [];
    for (var sub in subs) {
      ref = ref.collection(sub.col.name).doc(sub.doc);
    }

    map['docID'] = doc;
    if (subs.isNotEmptyAndNull) {
      map['docID'] = subs.last.doc ?? ref.id;
    }

    final fun = ref.set(map);

    final r = await _function(fun);

    if (r.hasError) {
      return FirestoreResponse(exception: r.exception);
    }

    return FirestoreResponse(response: true, docID: ref.id);
  }

  static Future<FirestoreResponse<List<MService>>> getServices({
    int limit = 5,
    List<MapEntry<String, Object>>? equalTo,
    DateTime? lastDate,
  }) async {
    var ref = _shopInstance
        .collection(FirestoreCol.services.name)
        .orderBy("createdAt", descending: true);

    if (lastDate != null) {
      ref = ref.startAfter([Timestamp.fromDate(lastDate)]);
    }

    if (equalTo.isNotEmptyAndNull) {
      for (var e in equalTo!) {
        ref = ref.where(e.key, isEqualTo: e.value);
      }
    }

    final fun = ref.limit(limit).get();

    final r = await _function<QuerySnapshot<Map<String, dynamic>>>(fun);

    if (r.hasError) {
      return FirestoreResponse(exception: r.exception);
    }

    final services = r.response?.docs.map((e) {
          final s = MService.fromJson(e.data());
          s.docID = e.id;
          return s;
        }).toList() ??
        [];

    Timestamp? lD;

    try {
      lD = r.response?.docs.last.data()['createdAt'] as Timestamp;
    } catch (_) {}

    return FirestoreResponse(response: services, lastDate: lD);
  }

  static MCustomer? _findCustomerLocal(String id) {
    return _customers.firstWhereOrNull((e) => e.phone.toString() == id);
  }

  static Future<FirestoreResponse<List<MCustomer>>> getCustomers({
    required MapEntry<String, Object> equalTo,
    int limit = 10,
  }) async {
    final fun = _customerInstance
        .where(equalTo.key, isEqualTo: equalTo.value)
        .limit(limit)
        .get();

    final r = await _function<QuerySnapshot<Map<String, dynamic>>>(fun);

    if (r.hasError) return FirestoreResponse(exception: r.exception);

    List<MCustomer> customers = [];

    for (var e in r.response!.docs) {
      final c = MCustomer.fromJson(e.data());
      _addLocalCustomer(c);
      customers.add(c);
    }

    return FirestoreResponse(response: customers);
  }

  static Future<FirestoreResponse<List<MVehicle>>> getVehicles({
    required MapEntry<String, Object> equalTo,
    int limit = 5,
  }) async {
    final fun = _vehicleInstance
        .where(equalTo.key, isEqualTo: equalTo.value)
        .limit(limit)
        .get();

    final r = await _function<QuerySnapshot<Map<String, dynamic>>>(fun);

    if (r.hasError) return FirestoreResponse(exception: r.exception);

    List<MVehicle> vehicles = [];

    for (var e in r.response!.docs) {
      final v = MVehicle.fromJson(e.data());
      vehicles.add(v);
    }

    return FirestoreResponse(response: vehicles);
  }

  static Future<FirestoreResponse<MCustomer>> getCustomer({
    required String id,
  }) async {
    final localCustomer = _findCustomerLocal(id);

    if (localCustomer != null) {
      return FirestoreResponse(response: localCustomer);
    }

    final fun =
        _shopInstance.collection(FirestoreCol.customers.name).doc(id).get();

    final result = await _function<DocumentSnapshot<Map<String, dynamic>>>(fun);

    if (result.hasError) {
      return FirestoreResponse(exception: result.exception);
    }

    if (!result.response!.exists) {
      return FirestoreResponse();
    }

    final c = MCustomer.fromJson(result.response!.data()!);
    _addLocalCustomer(c);

    return FirestoreResponse(response: c);
  }

  static void _addLocalCustomer(MCustomer c) {
    if (_customers.indexWhere((e) => e.phone == c.phone) == -1) {
      _customers.add(c);
    }
  }

  static String getDocId(FirestoreCol col) {
    return _instance.collection(col.name).doc().id;
  }
}
