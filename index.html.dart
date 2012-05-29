#import('dart:html');
#import('splay.dart', prefix: "s");

s.SplayTree tree = null;

void insertClick(event) {
  try {
    InputElement keyEl = document.query('#keyText');
    InputElement valueEl = document.query('#valueText');
    
    int key = Math.parseInt(keyEl.value);
    int value = Math.parseInt(valueEl.value);

    tree.insert(key, value);
    window.postMessage(tree.genD3(), '*');
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
    window.postMessage(tree.genD3(), '*');
  }
  catch (BadNumberFormatException e) {
    print(e.toString());
  }
}

void searchClick(event) {
  print('hallo');
  try {
    InputElement keyEl = document.query('#keyText');
    InputElement valueEl = document.query('#valueText');
    int key = Math.parseInt(keyEl.value);
    
    var result = tree.search(key);
    valueEl.value = '' + result['val'];
    window.postMessage(tree.genD3(), '*');
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
  
  tree.insert(4,1);
  tree.insert(3,2);
  tree.insert(5,3);
  
  window.postMessage(tree.genD3(), '*');
}