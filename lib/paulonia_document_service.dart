library paulonia_document_service;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:paulonia_utils/paulonia_utils.dart';
import 'package:paulonia_error_service/paulonia_error_service.dart';


class PauloniaDocumentService{

  /// Get a document snapshot from a document reference
  ///
  /// This function verifies if there is network. If there is, it gets the document
  /// from the server, otherwise it gets the document from cache.
  ///
  /// Set [cache] to true to force get the document from cache
  /// Set [forceServer] to true to force get the document from server. If there is not
  /// network, it returns null.
  static Future<DocumentSnapshot> getDoc(
    DocumentReference docRef,
    bool cache, {
    bool forceServer = false
  }) async{
    try{
      if(PUtils.isOnTest()) return docRef.get();
      Source source = Source.serverAndCache;
      bool networkFlag = await PUtils.checkNetwork();
      if(cache || !networkFlag){
        if(forceServer && !cache) return null;
        source = Source.cache;
      }
      return await docRef.get(GetOptions(source: source));
    }
    catch(error){
      print(error);
      if(error.runtimeType == PlatformException) return getDoc(docRef, false);
      PauloniaErrorService.sendError(error);
      return null;
    }
  }

  /// Get all documents of a collection reference
  ///
  /// This function verifies if there is network. If there is, it gets the documents
  /// from the server, otherwise it gets the documents from cache.
  ///
  /// Set [cache] to true to force get the documents from cache
  /// Set [forceServer] to true to force get the documents from server. If there is not
  /// network, it returns null.
  static Future<QuerySnapshot> getAll(
    CollectionReference collRef,
    bool cache, {
    bool forceServer = false
  }) async{
    try {
      if (PUtils.isOnTest()) return collRef.get();
      Source source = Source.serverAndCache;
      bool networkFlag = await PUtils.checkNetwork();
      if (cache || !networkFlag) {
        if (forceServer && !cache) return null;
        source = Source.cache;
      }
      return await collRef.get(GetOptions(source: source));
    }
    catch(error){
      if(error.runtimeType == PlatformException) return getAll(collRef, false);
      PauloniaErrorService.sendError(error);
      return null;
    }
  }

  /// Get a query snapshot from a query
  ///
  /// This function verifies if there is network. If there is, it gets the documents
  /// from the server, otherwise it gets the documents from cache.
  ///
  /// Set [cache] to true to force get the documents from cache
  /// Set [forceServer] to true to force get the documents from server. If there is not
  /// network, it returns null.
  static Future<QuerySnapshot> runQuery(Query query, bool cache, {bool forceServer = false}) async{
    try {
      if (PUtils.isOnTest()) return query.get();
      Source source = Source.serverAndCache;
      bool networkFlag = await PUtils.checkNetwork();
      if (cache || !networkFlag) {
        if (forceServer && !cache) return null;
        source = Source.cache;
      }
      return await query.get(GetOptions(source: source));
    }
    catch(error){
      if(error.runtimeType == PlatformException) return runQuery(query, false);
      PauloniaErrorService.sendError(error);
      return null;
    }
  }

  /// Get a query snapshot stream from a query
  static Stream<QuerySnapshot> getStreamByQuery(Query query){
    return query.snapshots();
  }

}