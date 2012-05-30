#import('dart:html');
#import('dart:json');
#import('splay.dart', prefix: "s");

s.SplayTree tree = null;

void redrawTree() {
  window.postMessage(tree.genD3(), '*');
  window.localStorage['splayTree'] = JSON.stringify(tree.genJSON());
}

void insertClick(event) {
  try {
    InputElement keyEl = document.query('#keyText');
    InputElement valueEl = document.query('#valueText');
    
    int key = Math.parseInt(keyEl.value);
    int value = Math.parseInt(valueEl.value);

    tree.insert(key, value);
    redrawTree();
  }
  catch (BadNumberFormatException e) {
    print(e.toString());
  }
}

void removeClick(event) {
  try {
    InputElement keyEl = document.query('#keyText');
    int key = Math.parseInt(keyEl.value);
    
    tree.remove(key);
    redrawTree();
  }
  catch (BadNumberFormatException e) {
    print(e.toString());
  }
}

void searchClick(event) {
  try {
    InputElement keyEl = document.query('#keyText');
    InputElement valueEl = document.query('#valueText');
    int key = Math.parseInt(keyEl.value);
    
    var result = tree.search(key);
    valueEl.value = '' + result['val'];
    redrawTree();
  }
  catch (BadNumberFormatException e) {
    print(e.toString());
  }
}

void main() {
  document.query('#insertBtn').on.click.add(insertClick);
  document.query('#removeBtn').on.click.add(removeClick);
  document.query('#searchBtn').on.click.add(searchClick);
  
  tree = new s.SplayTree();
  
  // check local storage
  String splayTreeStr = window.localStorage['splayTree'];
  if (splayTreeStr != null) {
    var splayTreeJSON = JSON.parse(splayTreeStr);
    tree.parseJSON(splayTreeJSON);
  }
  
  window.postMessage(tree.genD3(), '*');
}