abstract class Repository<T> {
  void saveElt(Map<String, dynamic> elmt);
  void listElts({String? sortby});
  void updateElt(String id, T newelt);
  void deleteElt(String id);
}
