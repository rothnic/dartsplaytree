#library('splay');

class SplayEntry {
  int _key;
  int _value;
  SplayEntry _parent;
  SplayEntry _left;
  SplayEntry _right;
  
  SplayEntry(this._key, this._value) {
    this._parent = null;
    this._left = null;
    this._right = null;
  }
  
  int getKey() => _key;
  int getValue() => _value;
  
  SplayEntry getParent() => _parent;
  void setParent(parent) {
    this._parent = parent;
  }
  
  SplayEntry getLeft() => _left;
  void setLeft(left) {
    this._left = left;
    if (left != null) {
      left.setParent(this);
    }
  }
  
  SplayEntry getRight() => _right;
  void setRight(right) {
    this._right = right;
    if (right != null) {
      right.setParent(this);
    }
  }
  
  void replace(SplayEntry old, SplayEntry entry) {
    if (this._left === old) {
      this.setLeft(entry);
    }
    else if (this._right === old) {
      this.setRight(entry);
    }
    else {
      assert(false);
    }
  }
  
  genJSON() {
    var jsonLeft = null, jsonRight = null;
    if (this._left != null) {
      jsonLeft = this._left.genJSON();
    }
    if (this._right != null) {
      jsonRight = this._right.genJSON();
    }
    return 
      { 
        'key' : this._key,
        'value' : this._value,
        'left' : jsonLeft,
        'right' : jsonRight
      };
  }
  
  genD3() {
    var jsonLeft = {'name':'null'}; 
    var jsonRight = {'name':'null'};
    if (this._left != null) {
      jsonLeft = this._left.genD3();
    }
    if (this._right != null) {
      jsonRight = this._right.genD3();
    }
    return 
      { 
        'name' : '' + this._key + ' / ' + this._value,
        'children' : [jsonLeft, jsonRight]
      };
  }
}

class SplayTree {
  SplayEntry _super;
  int _num;
  
  SplayTree() {
    _super = new SplayEntry(0, 0);
  }
  
  _splay(SplayEntry entry) {
    assert(entry != null);
    assert(entry != this._super);
    
    SplayEntry parent = entry.getParent();
    if (parent == this._super) {
      return;
    }
    
    SplayEntry grandparent = parent.getParent();
    if (parent.getLeft() === entry) {
      if (grandparent === this._super) {
        grandparent.replace(parent, entry);
        parent.setLeft(entry.getRight());
        entry.setRight(parent);
      }
      else if (grandparent.getLeft() === parent) {
        grandparent.getParent().replace(grandparent, entry);
        grandparent.setLeft(parent.getRight());
        parent.setRight(grandparent);
        parent.setLeft(entry.getRight());
        entry.setRight(parent);
      }
      else {
        grandparent.getParent().replace(grandparent, entry);
        grandparent.setRight(entry.getLeft());
        entry.setLeft(grandparent);
        parent.setLeft(entry.getRight());
        entry.setRight(parent);
      }
    }
    else {
      if (grandparent === this._super) {
        grandparent.replace(parent, entry);
        parent.setRight(entry.getLeft());
        entry.setLeft(parent);
      }
      else if (grandparent.getRight() === parent) {
        grandparent.getParent().replace(grandparent, entry);
        grandparent.setRight(parent.getLeft());
        parent.setLeft(grandparent);
        parent.setRight(entry.getLeft());
        entry.setLeft(parent);
      }
      else {
        grandparent.getParent().replace(grandparent, entry);
        grandparent.setLeft(entry.getRight());
        entry.setRight(grandparent);
        parent.setRight(entry.getLeft());
        entry.setLeft(parent);
      }
    }
    
    this._splay(entry);
  }
  
  SplayEntry _search(int key, SplayEntry current) {
    if (current == null) {
      return null;
    }
    if (current.getKey() == key) {
      return current;
    }
    else if (key < current.getKey()) {
      if (current.getLeft() == null) {
        return current;
      } else {
        return _search(key, current.getLeft());
      }
    }
    else {
      if (current.getRight() == null) {
        return current;
      }
      else {
        return _search(key, current.getRight());
      }
    }
  }
  
  bool insert(int key, int value) {
    SplayEntry newEntry = new SplayEntry(key, value);
    SplayEntry searchResult = this._search(key, this._super.getLeft());
    if (searchResult == null) {
      this._super.setLeft(newEntry);
      return true;
    }
    else if (searchResult.getKey() == key) {
      return false;
    }
    else {
      this._splay(searchResult);
      this._super.setLeft(newEntry);
      if (searchResult.getKey() < key) {
        newEntry.setLeft(searchResult);
        newEntry.setRight(searchResult.getRight());
        searchResult.setRight(null);
      }
      else {
        newEntry.setRight(searchResult);
        newEntry.setLeft(searchResult.getLeft());
        searchResult.setLeft(null);
      }
      return true;
    }
  }
  
  search(int key) {
    SplayEntry result = this._search(key, this._super.getLeft());
    if (result == null || result.getKey() != key) {
      return {"found":false, "val":0 };
    }
    else {
      this._splay(result);
      return {"found":true, "val":result.getValue() };
    }
  }
  
  bool remove(int key) {
    SplayEntry result = this._search(key, this._super.getLeft());
    if (result == null || result.getKey() != key) {
      return false;
    }
    else {
      this._splay(result);
      SplayEntry replacement = null;
      if (result.getLeft() != null) {
        replacement = result.getLeft();
        while(replacement.getRight() != null) {
          replacement = replacement.getRight();
        }
      }
      else if (result.getRight() != null) {
        replacement = result.getRight();
        while (replacement.getLeft() != null) {
          replacement = replacement.getLeft();
        }
      }
      if (replacement != null) {
        replacement.getParent().replace(replacement, null);
      }
      this._super.setLeft(replacement);
      replacement.setLeft(result.getLeft());
      replacement.setRight(result.getRight());
      return true;
    }
  }
  
  genJSON() {
    if (this._super.getLeft() != null) {
      return this._super.getLeft().genJSON();
    }
    else {
      return {};
    }
  }
  
  SplayEntry _parseJSON(var subTreeJSON) {
    if (subTreeJSON == null) {
      return null;
    }
    else {
      SplayEntry left = _parseJSON(subTreeJSON['left']);
      SplayEntry right = _parseJSON(subTreeJSON['right']);
      SplayEntry node = new SplayEntry(subTreeJSON['key'], subTreeJSON['value']);
      node.setLeft(left);
      node.setRight(right);
      return node;
    }
  }
  
  parseJSON(var splayTreeJSON) {
    SplayEntry root = this._parseJSON(splayTreeJSON);
    this._super.setLeft(root);
  }
  
  genD3() {
    if (this._super.getLeft() != null) {
      return this._super.getLeft().genD3();
    }
    else {
      return {};
    }
  }
}
