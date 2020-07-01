class Binarysearchtree:
    def __init__(self):
        self.root = None
        self.size = 0
    
    def length(self):
        return self.size
    
    def __len__(self):
        return self.size
    
    def __iter__(self):
        return self.root.__iter__()
    
    def put(self,key,value):
        if self.root:
            self._put(key,value,self.root)
        else:
            self.root = Treenode(key,value)
        self.size = self.size + 1
        
    def _put(self,key,value,currentnode):
        if key < currentnode.key:
            if currentnode.hasleftchild():
                self._put(key,value,currentnode.leftchild)
            else:
                currentnode.leftchild = Treenode(key,value,parent = currentnode)
        else:
            if currentnode.hasrightchild():
                self._put(key,value,currentnode.rightchild)
            else:
                currentnode.rightchild = Treenode(key,value,parent = currentnode)            
    
    def __setitem__(self,key,value):
        self.put(key,value)
        
    def _get(self,key,currentnode):
        if key < currentnode.key:
            return self._get(key,currentnode.leftchild)
        elif key > currentnode.key:
            return self._get(key,currentnode.rightchild)
        elif key == currentnode.key:
            return currentnode.payload
        else:
            return None
   
    def __getitem__(self,key):
        return self.get(key)
    
    def __contains__(self,key):
        if self._get(key,self.root):
            return True
        else:
            return False
    
    def get(self,key):
        if self.root:
            res = self._get(key,self.root)
            if res:
                return res
            else:
                return None
        else:
            return None
    
    def delete(self,key):
        if self.size > 1:
            value = self._get(key,self.root)
            if value:
                self.remove(value)
                self.size = self.size - 1
            else:
                raise KeyError('key not in tree')
        elif self.size == 1 and self.key == key:
            self.root = None
            self.size = 0
        else:
            raise KeyError('key not in tree')
    def findsuccsor(self):
        succ = None
        if self.hasrightchild():
            succ = self.rightchild.findmin()
        return succ
    
    def findmin(self):
        current = self
        while current.hasleftchild():
            current = current.leftchild
        return current
                
    def split(self):
        if self.isleaf():
            self.leftchild = None
        else:
            self.parent.leftchild = self.rightchild
            self.rightchild.parent = self.parent
    
    def remove(self,currentnode):
        if currentnode.isleaf():
            if currentnode.isleftchild():
                currentnode.parent.leftchild = None
            else:
                currentnode.parent.rightchild = None
        elif currentnode.hasbothchild():
            succ = currentnode.findsuccsor()
            succ.split()
            currentnode.key = succ.key
            currentnode.payload = succ.payload
        else:
            if currentnode.isleftchild():
                if currentnode.hasleftchild():
                    currentnode.parent.leftchild = currentnode.leftchild
                    currentnode.leftchild.parent = currentnode.parent
                else:
                    currentnode.parent.rightchild = currentnode.rightchild
                    currentnode.rightchild.parent = currentnode.parent
            elif currentnode.isrightchild():
                if currentnode.hasleftchild():
                    currentnode.parent.rightchild = currentnode.leftchild
                    currentnode.leftchild.parent = currentnode.parent
                else:
                    currentnode.parent.rightchild = currentnode.rightchild
                    currentnode.rightchild.parent = currentnode.parent
            else:
                if currentnode.hasrightchild():
                    currentnode.replacenode(currentnode.rightchild.key,
                                            currentnode.rightchild.payload,
                                            currentnode.rightchild.leftchild,
                                            currentnode.rightchild.rightchild)
                else:
                    currentnode.replacenode(currentnode.leftchild.key,
                                            currentnode.leftchild.payload,
                                            currentnode.leftchild.leftchild,
                                            currentnode.leftchild.rightchild)
        
class Treenode:
    def __init__(self,key,value,left = None,\
                 right = None,parent = None):
        self.key = key
        self.payload = value
        self.leftchild = left
        self.rightchild = right
        self.parent = parent
    
    def hasleftchild(self):
        return self.leftchild
    
    def hasrightchild(self):
        return self.rightchild
    
    def isleftchild(self):
        return self.parent.leftchild == self
    
    def isrightchild(self):
        return self.parent.rightchild == self
    
    def isroot(self):
        return not self.parent
    
    def isleaf(self):
        return not (self.leftchild or self.rightchild)
    
    def hasanychild(self):
        return self.leftchild or self.rightchild
    
    def hasbothchild(self):
        return self.leftchild and self.rightchild
    
    def replacenode(self,key,value,lc,rc):
        self.key = key
        self.payload = value
        self.leftchild = lc
        self.rightchild = rc
        if self.hasleftchild():
            self.leftchild.parent = self
        if self.hasrightchild():
            self.rightchild.parent = self
    
    def __iter__(self):
        if self:
            if self.hasleftchild():
                for ele in self.leftchild:
                    yield ele
            yield self.root
            if self.hasrightchild():
                for ele in self.rightchild:
                    yield ele
                    
mytree = Binarysearchtree()
mytree[2] = 'blue'
mytree[3] = 'yellow'        
print(2 in mytree)
print(mytree[2])
