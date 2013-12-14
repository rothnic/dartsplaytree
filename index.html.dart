import 'dart:html';
import 'dart:convert' show JSON;
import 'splay.dart' as s;

s.SplayTree tree = null;
InputElement keyEl = null;
InputElement valueEl = null;

// redraw d3 tree
void redrawTree() {
  window.postMessage(tree.genD3(), '*');
  // save current tree in local storage
  window.localStorage['splayTree'] = JSON.encoder.convert(tree.genJSON());
}

void insertClick(event) {
  try {
    int key = int.parse(keyEl.value);
    int value = int.parse(valueEl.value);

    tree.insert(key, value);
    redrawTree();
  }
  catch (e) {
    print(e.toString());
  }
}

void removeClick(event) {
  try {
    int key = int.parse(keyEl.value);
    
    tree.remove(key);
    redrawTree();
  }
  catch (e) {
    print(e.toString());
  }
}

void searchClick(event) {
  try {
    int key = int.parse(keyEl.value);
    
    var result = tree.search(key);
    valueEl.value = '' + result['val'];
    redrawTree();
  }
  catch (e) {
    print(e.toString());
  }
}

void keyTextKeyDown(KeyboardEvent event) {
  // block non numbers
  if (event.keyCode != 8 
   && event.keyCode != 9 
   && event.keyCode != 37
   && event.keyCode != 38 
   && event.keyCode != 39 
   && event.keyCode != 40 
   && (event.keyCode < 48 || event.keyCode > 58)) {
    event.preventDefault();
  }
}

void main() {
  keyEl = document.query('#keyText');
  valueEl = document.query('#valueText');
  keyEl.onKeyDown.listen(keyTextKeyDown);
  valueEl.onKeyDown.listen(keyTextKeyDown);
  document.query('#insertBtn').onClick.listen(insertClick);
  document.query('#removeBtn').onClick.listen(removeClick);
  document.query('#searchBtn').onClick.listen(searchClick);
  
  tree = new s.SplayTree();
  
  // check local storage
  String splayTreeStr = window.localStorage['splayTree'];
  var splayTreeJSON = null;
  if (splayTreeStr != null) {
    splayTreeJSON = JSON.decode(splayTreeStr);
    tree.parseJSON(splayTreeJSON);
  }
  else {
    // add default values
    splayTreeJSON = 
      {'key' : 5,
       'value' : 432,
       'left' : {
         'key' : 10,
         'value' : 33,
         'left' : null,
         'right' :null
        },
       'right' : {
         'key' : 1,
         'value' : 333,
         'left' : null,
         'right' :null
        }
      };
  }
  tree.parseJSON(splayTreeJSON);
  redrawTree();
}