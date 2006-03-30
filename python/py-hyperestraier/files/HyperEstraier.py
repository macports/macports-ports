# This file was created automatically by SWIG 1.3.29.
# Don't modify this file, modify the SWIG interface instead.
# This file is compatible with both classic and new-style classes.

import _HyperEstraier
import new
new_instancemethod = new.instancemethod
def _swig_setattr_nondynamic(self,class_type,name,value,static=1):
    if (name == "thisown"): return self.this.own(value)
    if (name == "this"):
        if type(value).__name__ == 'PySwigObject':
            self.__dict__[name] = value
            return
    method = class_type.__swig_setmethods__.get(name,None)
    if method: return method(self,value)
    if (not static) or hasattr(self,name):
        self.__dict__[name] = value
    else:
        raise AttributeError("You cannot add attributes to %s" % self)

def _swig_setattr(self,class_type,name,value):
    return _swig_setattr_nondynamic(self,class_type,name,value,0)

def _swig_getattr(self,class_type,name):
    if (name == "thisown"): return self.this.own()
    method = class_type.__swig_getmethods__.get(name,None)
    if method: return method(self)
    raise AttributeError,name

def _swig_repr(self):
    try: strthis = "proxy of " + self.this.__repr__()
    except: strthis = ""
    return "<%s.%s; %s >" % (self.__class__.__module__, self.__class__.__name__, strthis,)

import types
try:
    _object = types.ObjectType
    _newclass = 1
except AttributeError:
    class _object : pass
    _newclass = 0
del types


class PySwigIterator(_object):
    __swig_setmethods__ = {}
    __setattr__ = lambda self, name, value: _swig_setattr(self, PySwigIterator, name, value)
    __swig_getmethods__ = {}
    __getattr__ = lambda self, name: _swig_getattr(self, PySwigIterator, name)
    def __init__(self): raise AttributeError, "No constructor defined"
    __repr__ = _swig_repr
    __swig_destroy__ = _HyperEstraier.delete_PySwigIterator
    __del__ = lambda self : None;
    def value(*args): return _HyperEstraier.PySwigIterator_value(*args)
    def incr(*args): return _HyperEstraier.PySwigIterator_incr(*args)
    def decr(*args): return _HyperEstraier.PySwigIterator_decr(*args)
    def distance(*args): return _HyperEstraier.PySwigIterator_distance(*args)
    def equal(*args): return _HyperEstraier.PySwigIterator_equal(*args)
    def copy(*args): return _HyperEstraier.PySwigIterator_copy(*args)
    def next(*args): return _HyperEstraier.PySwigIterator_next(*args)
    def previous(*args): return _HyperEstraier.PySwigIterator_previous(*args)
    def advance(*args): return _HyperEstraier.PySwigIterator_advance(*args)
    def __eq__(*args): return _HyperEstraier.PySwigIterator___eq__(*args)
    def __ne__(*args): return _HyperEstraier.PySwigIterator___ne__(*args)
    def __iadd__(*args): return _HyperEstraier.PySwigIterator___iadd__(*args)
    def __isub__(*args): return _HyperEstraier.PySwigIterator___isub__(*args)
    def __add__(*args): return _HyperEstraier.PySwigIterator___add__(*args)
    def __sub__(*args): return _HyperEstraier.PySwigIterator___sub__(*args)
    def __iter__(self): return self
PySwigIterator_swigregister = _HyperEstraier.PySwigIterator_swigregister
PySwigIterator_swigregister(PySwigIterator)

class StrVector(_object):
    __swig_setmethods__ = {}
    __setattr__ = lambda self, name, value: _swig_setattr(self, StrVector, name, value)
    __swig_getmethods__ = {}
    __getattr__ = lambda self, name: _swig_getattr(self, StrVector, name)
    __repr__ = _swig_repr
    def iterator(*args): return _HyperEstraier.StrVector_iterator(*args)
    def __iter__(self): return self.iterator()
    def __nonzero__(*args): return _HyperEstraier.StrVector___nonzero__(*args)
    def __len__(*args): return _HyperEstraier.StrVector___len__(*args)
    def pop(*args): return _HyperEstraier.StrVector_pop(*args)
    def __getslice__(*args): return _HyperEstraier.StrVector___getslice__(*args)
    def __setslice__(*args): return _HyperEstraier.StrVector___setslice__(*args)
    def __delslice__(*args): return _HyperEstraier.StrVector___delslice__(*args)
    def __delitem__(*args): return _HyperEstraier.StrVector___delitem__(*args)
    def __getitem__(*args): return _HyperEstraier.StrVector___getitem__(*args)
    def __setitem__(*args): return _HyperEstraier.StrVector___setitem__(*args)
    def append(*args): return _HyperEstraier.StrVector_append(*args)
    def empty(*args): return _HyperEstraier.StrVector_empty(*args)
    def size(*args): return _HyperEstraier.StrVector_size(*args)
    def clear(*args): return _HyperEstraier.StrVector_clear(*args)
    def swap(*args): return _HyperEstraier.StrVector_swap(*args)
    def get_allocator(*args): return _HyperEstraier.StrVector_get_allocator(*args)
    def begin(*args): return _HyperEstraier.StrVector_begin(*args)
    def end(*args): return _HyperEstraier.StrVector_end(*args)
    def rbegin(*args): return _HyperEstraier.StrVector_rbegin(*args)
    def rend(*args): return _HyperEstraier.StrVector_rend(*args)
    def pop_back(*args): return _HyperEstraier.StrVector_pop_back(*args)
    def erase(*args): return _HyperEstraier.StrVector_erase(*args)
    def __init__(self, *args): 
        this = _HyperEstraier.new_StrVector(*args)
        try: self.this.append(this)
        except: self.this = this
    def push_back(*args): return _HyperEstraier.StrVector_push_back(*args)
    def front(*args): return _HyperEstraier.StrVector_front(*args)
    def back(*args): return _HyperEstraier.StrVector_back(*args)
    def assign(*args): return _HyperEstraier.StrVector_assign(*args)
    def resize(*args): return _HyperEstraier.StrVector_resize(*args)
    def insert(*args): return _HyperEstraier.StrVector_insert(*args)
    def reserve(*args): return _HyperEstraier.StrVector_reserve(*args)
    def capacity(*args): return _HyperEstraier.StrVector_capacity(*args)
    __swig_destroy__ = _HyperEstraier.delete_StrVector
    __del__ = lambda self : None;
StrVector_swigregister = _HyperEstraier.StrVector_swigregister
StrVector_swigregister(StrVector)

class IntVector(_object):
    __swig_setmethods__ = {}
    __setattr__ = lambda self, name, value: _swig_setattr(self, IntVector, name, value)
    __swig_getmethods__ = {}
    __getattr__ = lambda self, name: _swig_getattr(self, IntVector, name)
    __repr__ = _swig_repr
    def iterator(*args): return _HyperEstraier.IntVector_iterator(*args)
    def __iter__(self): return self.iterator()
    def __nonzero__(*args): return _HyperEstraier.IntVector___nonzero__(*args)
    def __len__(*args): return _HyperEstraier.IntVector___len__(*args)
    def pop(*args): return _HyperEstraier.IntVector_pop(*args)
    def __getslice__(*args): return _HyperEstraier.IntVector___getslice__(*args)
    def __setslice__(*args): return _HyperEstraier.IntVector___setslice__(*args)
    def __delslice__(*args): return _HyperEstraier.IntVector___delslice__(*args)
    def __delitem__(*args): return _HyperEstraier.IntVector___delitem__(*args)
    def __getitem__(*args): return _HyperEstraier.IntVector___getitem__(*args)
    def __setitem__(*args): return _HyperEstraier.IntVector___setitem__(*args)
    def append(*args): return _HyperEstraier.IntVector_append(*args)
    def empty(*args): return _HyperEstraier.IntVector_empty(*args)
    def size(*args): return _HyperEstraier.IntVector_size(*args)
    def clear(*args): return _HyperEstraier.IntVector_clear(*args)
    def swap(*args): return _HyperEstraier.IntVector_swap(*args)
    def get_allocator(*args): return _HyperEstraier.IntVector_get_allocator(*args)
    def begin(*args): return _HyperEstraier.IntVector_begin(*args)
    def end(*args): return _HyperEstraier.IntVector_end(*args)
    def rbegin(*args): return _HyperEstraier.IntVector_rbegin(*args)
    def rend(*args): return _HyperEstraier.IntVector_rend(*args)
    def pop_back(*args): return _HyperEstraier.IntVector_pop_back(*args)
    def erase(*args): return _HyperEstraier.IntVector_erase(*args)
    def __init__(self, *args): 
        this = _HyperEstraier.new_IntVector(*args)
        try: self.this.append(this)
        except: self.this = this
    def push_back(*args): return _HyperEstraier.IntVector_push_back(*args)
    def front(*args): return _HyperEstraier.IntVector_front(*args)
    def back(*args): return _HyperEstraier.IntVector_back(*args)
    def assign(*args): return _HyperEstraier.IntVector_assign(*args)
    def resize(*args): return _HyperEstraier.IntVector_resize(*args)
    def insert(*args): return _HyperEstraier.IntVector_insert(*args)
    def reserve(*args): return _HyperEstraier.IntVector_reserve(*args)
    def capacity(*args): return _HyperEstraier.IntVector_capacity(*args)
    __swig_destroy__ = _HyperEstraier.delete_IntVector
    __del__ = lambda self : None;
IntVector_swigregister = _HyperEstraier.IntVector_swigregister
IntVector_swigregister(IntVector)

class StrStrMap(_object):
    __swig_setmethods__ = {}
    __setattr__ = lambda self, name, value: _swig_setattr(self, StrStrMap, name, value)
    __swig_getmethods__ = {}
    __getattr__ = lambda self, name: _swig_getattr(self, StrStrMap, name)
    __repr__ = _swig_repr
    def iterator(*args): return _HyperEstraier.StrStrMap_iterator(*args)
    def __iter__(self): return self.iterator()
    def __nonzero__(*args): return _HyperEstraier.StrStrMap___nonzero__(*args)
    def __len__(*args): return _HyperEstraier.StrStrMap___len__(*args)
    def __getitem__(*args): return _HyperEstraier.StrStrMap___getitem__(*args)
    def __setitem__(*args): return _HyperEstraier.StrStrMap___setitem__(*args)
    def __delitem__(*args): return _HyperEstraier.StrStrMap___delitem__(*args)
    def has_key(*args): return _HyperEstraier.StrStrMap_has_key(*args)
    def keys(*args): return _HyperEstraier.StrStrMap_keys(*args)
    def values(*args): return _HyperEstraier.StrStrMap_values(*args)
    def items(*args): return _HyperEstraier.StrStrMap_items(*args)
    def __contains__(*args): return _HyperEstraier.StrStrMap___contains__(*args)
    def key_iterator(*args): return _HyperEstraier.StrStrMap_key_iterator(*args)
    def value_iterator(*args): return _HyperEstraier.StrStrMap_value_iterator(*args)
    def __iter__(self): return self.key_iterator()
    def iterkeys(self): return self.key_iterator()
    def itervalues(self): return self.value_iterator()
    def iteritems(self): return self.iterator()
    def __init__(self, *args): 
        this = _HyperEstraier.new_StrStrMap(*args)
        try: self.this.append(this)
        except: self.this = this
    def empty(*args): return _HyperEstraier.StrStrMap_empty(*args)
    def size(*args): return _HyperEstraier.StrStrMap_size(*args)
    def clear(*args): return _HyperEstraier.StrStrMap_clear(*args)
    def swap(*args): return _HyperEstraier.StrStrMap_swap(*args)
    def get_allocator(*args): return _HyperEstraier.StrStrMap_get_allocator(*args)
    def begin(*args): return _HyperEstraier.StrStrMap_begin(*args)
    def end(*args): return _HyperEstraier.StrStrMap_end(*args)
    def rbegin(*args): return _HyperEstraier.StrStrMap_rbegin(*args)
    def rend(*args): return _HyperEstraier.StrStrMap_rend(*args)
    def count(*args): return _HyperEstraier.StrStrMap_count(*args)
    def erase(*args): return _HyperEstraier.StrStrMap_erase(*args)
    def find(*args): return _HyperEstraier.StrStrMap_find(*args)
    def lower_bound(*args): return _HyperEstraier.StrStrMap_lower_bound(*args)
    def upper_bound(*args): return _HyperEstraier.StrStrMap_upper_bound(*args)
    __swig_destroy__ = _HyperEstraier.delete_StrStrMap
    __del__ = lambda self : None;
StrStrMap_swigregister = _HyperEstraier.StrStrMap_swigregister
StrStrMap_swigregister(StrStrMap)

class IOError(_object):
    __swig_setmethods__ = {}
    __setattr__ = lambda self, name, value: _swig_setattr(self, IOError, name, value)
    __swig_getmethods__ = {}
    __getattr__ = lambda self, name: _swig_getattr(self, IOError, name)
    __repr__ = _swig_repr
    def __init__(self, *args): 
        this = _HyperEstraier.new_IOError(*args)
        try: self.this.append(this)
        except: self.this = this
    __swig_destroy__ = _HyperEstraier.delete_IOError
    __del__ = lambda self : None;
IOError_swigregister = _HyperEstraier.IOError_swigregister
IOError_swigregister(IOError)

class Condition(_object):
    __swig_setmethods__ = {}
    __setattr__ = lambda self, name, value: _swig_setattr(self, Condition, name, value)
    __swig_getmethods__ = {}
    __getattr__ = lambda self, name: _swig_getattr(self, Condition, name)
    __repr__ = _swig_repr
    SURE = _HyperEstraier.Condition_SURE
    USUAL = _HyperEstraier.Condition_USUAL
    FAST = _HyperEstraier.Condition_FAST
    AGITO = _HyperEstraier.Condition_AGITO
    NOIDF = _HyperEstraier.Condition_NOIDF
    SIMPLE = _HyperEstraier.Condition_SIMPLE
    __swig_setmethods__["cond"] = _HyperEstraier.Condition_cond_set
    __swig_getmethods__["cond"] = _HyperEstraier.Condition_cond_get
    if _newclass:cond = property(_HyperEstraier.Condition_cond_get, _HyperEstraier.Condition_cond_set)
    def __init__(self, *args): 
        this = _HyperEstraier.new_Condition(*args)
        try: self.this.append(this)
        except: self.this = this
    __swig_destroy__ = _HyperEstraier.delete_Condition
    __del__ = lambda self : None;
    def set_phrase(*args): return _HyperEstraier.Condition_set_phrase(*args)
    def add_attr(*args): return _HyperEstraier.Condition_add_attr(*args)
    def set_order(*args): return _HyperEstraier.Condition_set_order(*args)
    def set_max(*args): return _HyperEstraier.Condition_set_max(*args)
    def set_options(*args): return _HyperEstraier.Condition_set_options(*args)
Condition_swigregister = _HyperEstraier.Condition_swigregister
Condition_swigregister(Condition)

class Document(_object):
    __swig_setmethods__ = {}
    __setattr__ = lambda self, name, value: _swig_setattr(self, Document, name, value)
    __swig_getmethods__ = {}
    __getattr__ = lambda self, name: _swig_getattr(self, Document, name)
    __repr__ = _swig_repr
    __swig_setmethods__["doc"] = _HyperEstraier.Document_doc_set
    __swig_getmethods__["doc"] = _HyperEstraier.Document_doc_get
    if _newclass:doc = property(_HyperEstraier.Document_doc_get, _HyperEstraier.Document_doc_set)
    def __init__(self, *args): 
        this = _HyperEstraier.new_Document(*args)
        try: self.this.append(this)
        except: self.this = this
    __swig_destroy__ = _HyperEstraier.delete_Document
    __del__ = lambda self : None;
    def add_attr(*args): return _HyperEstraier.Document_add_attr(*args)
    def add_text(*args): return _HyperEstraier.Document_add_text(*args)
    def add_hidden_text(*args): return _HyperEstraier.Document_add_hidden_text(*args)
    def id(*args): return _HyperEstraier.Document_id(*args)
    def attr_names(*args): return _HyperEstraier.Document_attr_names(*args)
    def attr(*args): return _HyperEstraier.Document_attr(*args)
    def cat_texts(*args): return _HyperEstraier.Document_cat_texts(*args)
    def texts(*args): return _HyperEstraier.Document_texts(*args)
    def dump_draft(*args): return _HyperEstraier.Document_dump_draft(*args)
    def make_snippet(*args): return _HyperEstraier.Document_make_snippet(*args)
    def hidden_texts(*args): return _HyperEstraier.Document_hidden_texts(*args)
Document_swigregister = _HyperEstraier.Document_swigregister
Document_swigregister(Document)

class Database(_object):
    __swig_setmethods__ = {}
    __setattr__ = lambda self, name, value: _swig_setattr(self, Database, name, value)
    __swig_getmethods__ = {}
    __getattr__ = lambda self, name: _swig_getattr(self, Database, name)
    __repr__ = _swig_repr
    ERRNOERR = _HyperEstraier.Database_ERRNOERR
    ERRINVAL = _HyperEstraier.Database_ERRINVAL
    ERRACCES = _HyperEstraier.Database_ERRACCES
    ERRLOCK = _HyperEstraier.Database_ERRLOCK
    ERRDB = _HyperEstraier.Database_ERRDB
    ERRIO = _HyperEstraier.Database_ERRIO
    ERRNOITEM = _HyperEstraier.Database_ERRNOITEM
    ERRMISC = _HyperEstraier.Database_ERRMISC
    DBREADER = _HyperEstraier.Database_DBREADER
    DBWRITER = _HyperEstraier.Database_DBWRITER
    DBCREAT = _HyperEstraier.Database_DBCREAT
    DBTRUNC = _HyperEstraier.Database_DBTRUNC
    DBNOLCK = _HyperEstraier.Database_DBNOLCK
    DBLCKNB = _HyperEstraier.Database_DBLCKNB
    DBPERFNG = _HyperEstraier.Database_DBPERFNG
    PDCLEAN = _HyperEstraier.Database_PDCLEAN
    ODCLEAN = _HyperEstraier.Database_ODCLEAN
    OPTNOPURGE = _HyperEstraier.Database_OPTNOPURGE
    OPTNODBOPT = _HyperEstraier.Database_OPTNODBOPT
    GDNOATTR = _HyperEstraier.Database_GDNOATTR
    GDNOTEXT = _HyperEstraier.Database_GDNOTEXT
    def __init__(self, *args): 
        this = _HyperEstraier.new_Database(*args)
        try: self.this.append(this)
        except: self.this = this
    __swig_destroy__ = _HyperEstraier.delete_Database
    __del__ = lambda self : None;
    def open(*args): return _HyperEstraier.Database_open(*args)
    def close(*args): return _HyperEstraier.Database_close(*args)
    def put_doc(*args): return _HyperEstraier.Database_put_doc(*args)
    def search(*args): return _HyperEstraier.Database_search(*args)
    __swig_getmethods__["err_msg"] = lambda x: _HyperEstraier.Database_err_msg
    if _newclass:err_msg = staticmethod(_HyperEstraier.Database_err_msg)
    def error(*args): return _HyperEstraier.Database_error(*args)
    def fatal(*args): return _HyperEstraier.Database_fatal(*args)
    def flush(*args): return _HyperEstraier.Database_flush(*args)
    def sync(*args): return _HyperEstraier.Database_sync(*args)
    def optimize(*args): return _HyperEstraier.Database_optimize(*args)
    def out_doc(*args): return _HyperEstraier.Database_out_doc(*args)
    def edit_doc(*args): return _HyperEstraier.Database_edit_doc(*args)
    def get_doc(*args): return _HyperEstraier.Database_get_doc(*args)
    def uri_to_id(*args): return _HyperEstraier.Database_uri_to_id(*args)
    def etch_doc(*args): return _HyperEstraier.Database_etch_doc(*args)
    def name(*args): return _HyperEstraier.Database_name(*args)
    def doc_num(*args): return _HyperEstraier.Database_doc_num(*args)
    def word_num(*args): return _HyperEstraier.Database_word_num(*args)
    def size(*args): return _HyperEstraier.Database_size(*args)
    def set_cache_size(*args): return _HyperEstraier.Database_set_cache_size(*args)
    def set_special_cache(*args): return _HyperEstraier.Database_set_special_cache(*args)
Database_swigregister = _HyperEstraier.Database_swigregister
Database_swigregister(Database)
Database_err_msg = _HyperEstraier.Database_err_msg

break_text = _HyperEstraier.break_text
break_text_perfng = _HyperEstraier.break_text_perfng


