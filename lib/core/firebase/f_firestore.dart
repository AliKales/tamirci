import 'package:caroby/caroby.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:tamirci/core/firebase/f_auth.dart';
import 'package:tamirci/core/models/m_customer.dart';
import 'package:tamirci/core/models/m_service.dart';

enum FirestoreCol {
  shops,
  customers,
  services,
}

class FirestoreSub {
  final FirestoreCol col;
  final String? doc;

  FirestoreSub({required this.col, this.doc});
}

class FirestoreResponse<T> {
  final T? response;
  final FirebaseException? exception;
  final String? docID;

  FirestoreResponse({this.response, this.exception, this.docID});

  bool get hasError {
    return exception != null ? true : false;
  }
}

final class FFirestore {
  const FFirestore._();

  static final _instance = FirebaseFirestore.instance;

  static final _shopInstance =
      _instance.collection(FirestoreCol.shops.name).doc(FAuth.uid);

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
    FirestoreCol col,
    String doc, {
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
    Map<String, dynamic> map,
  ) async {
    final fun = _instance.collection(col.name).doc(doc).update(map);

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

    final fun = ref.set(map);

    final r = await _function(fun);

    if (r.hasError) {
      return FirestoreResponse(exception: r.exception);
    }

    return FirestoreResponse(response: true, docID: ref.id);
  }

  static Future<FirestoreResponse<List<MService>>> getServices() async {
    final fun = _shopInstance
        .collection(FirestoreCol.services.name)
        .orderBy("createdAt", descending: true)
        .limit(5)
        .get();

    final r = await _function<QuerySnapshot<Map<String, dynamic>>>(fun);

    if (r.hasError) {
      return FirestoreResponse(exception: r.exception);
    }
    List<MService> services = [];
    for (var e in r.response!.docs) {
      final s = MService.fromJson(e.data());
      MCustomer? c;

      if (s.customerID.isNotEmptyAndNull) {
        final r = await getCustomer(s.customerID!);
        if (!r.hasError && r.response != null) {
          c = r.response;
        }
      }
      s.customer = c ??
          MCustomer(
            name: "Müşteri bulunamadı",
            surname: "Silinmiş olabilir veya bir hata meydana gelmiş olabilir",
          );

      services.add(s);
    }

    return FirestoreResponse(response: services);
  }

  static MCustomer? _findCustomerLocal(String id) {
    return _customers.firstWhereOrNull((e) => e.phone.toString() == id);
  }

  static Future<FirestoreResponse<MCustomer>> getCustomer(String id) async {
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
    _customers.add(c);

    return FirestoreResponse(response: c);
  }

  static String getDocId(FirestoreCol col) {
    return _instance.collection(col.name).doc().id;
  }
}
