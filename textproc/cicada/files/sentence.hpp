// -*- mode: c++ -*-
//
//  Copyright(C) 2010-2011 Taro Watanabe <taro.watanabe@nict.go.jp>
//

#ifndef __CICADA__SENTENCE__HPP__
#define __CICADA__SENTENCE__HPP__ 1

#include <iostream>
#include <vector>
#include <string>

#include <cicada/symbol.hpp>

#include <utils/hashmurmur3.hpp>
#include <utils/piece.hpp>

namespace cicada
{

  class Sentence
  {
  public:
    typedef cicada::Symbol  symbol_type;
    typedef cicada::Symbol  word_type;
    
  private:
    typedef std::vector<word_type, std::allocator<word_type> > sent_type;

  public:
    typedef sent_type::size_type              size_type;
    typedef sent_type::difference_type        difference_type;
    typedef sent_type::value_type             value_type;
    
    typedef sent_type::iterator               iterator;
    typedef sent_type::const_iterator         const_iterator;
    typedef sent_type::reverse_iterator       reverse_iterator;
    typedef sent_type::const_reverse_iterator const_reverse_iterator;
    typedef sent_type::reference              reference;
    typedef sent_type::const_reference        const_reference;
    
  public:
    Sentence() : __sent() {}
    Sentence(size_type __n) : __sent(__n) {}
    Sentence(size_type __n, const word_type& __word) : __sent(__n, __word) {}
    template <typename Iterator>
    Sentence(Iterator first, Iterator last) : __sent(first, last) {}
    Sentence(const utils::piece& x) { assign(x); }
    
    void assign(size_type __n, const word_type& __word) { __sent.assign(__n, __word); }
    template <typename Iterator>
    void assign(Iterator first, Iterator last) { __sent.assign(first, last); }
    void assign(const utils::piece& x);
    
    bool assign(std::string::const_iterator& iter, std::string::const_iterator end);
    bool assign(utils::piece::const_iterator& iter, utils::piece::const_iterator end);
    
    // insert/erase...
    iterator insert(iterator pos, const word_type& word) { return __sent.insert(pos, word); }
    void insert(iterator pos, size_type n, const word_type& word) { __sent.insert(pos, n, word); }
    template <typename Iterator>
    void insert(iterator pos, Iterator first, Iterator last) { __sent.insert(pos, first, last); }
    
    iterator erase(iterator pos) { return __sent.erase(pos); }
    iterator erase(iterator first, iterator last) { return __sent.erase(first, last); }
    
    void push_back(const word_type& word) { __sent.push_back(word); }
    void pop_back() { __sent.pop_back(); }
    
    void swap(Sentence& __x) { __sent.swap(__x.__sent); }
    
    void clear() { __sent.clear(); }
    void reserve(size_type __n) { __sent.reserve(__n); }
    void resize(size_type __n) { __sent.resize(__n); }
    void resize(size_type __n, const word_type& __word) { __sent.resize(__n, __word); }

    size_type size() const { return __sent.size(); }
    bool empty() const { return __sent.empty(); }
    
    inline const_iterator begin() const { return __sent.begin(); }
    inline       iterator begin()       { return __sent.begin(); }
    
    inline const_iterator end() const { return __sent.end(); }
    inline       iterator end()       { return __sent.end(); }
    
    inline const_reverse_iterator rbegin() const { return __sent.rbegin(); }
    inline       reverse_iterator rbegin()       { return __sent.rbegin(); }
    
    inline const_reverse_iterator rend() const { return __sent.rend(); }
    inline       reverse_iterator rend()       { return __sent.rend(); }
    
    inline const_reference operator[](size_type pos) const { return __sent[pos]; }
    inline       reference operator[](size_type pos)       { return __sent[pos]; }

    inline const_reference front() const { return __sent.front(); }
    inline       reference front()       { return __sent.front(); }
    
    inline const_reference back() const { return __sent.back(); }
    inline       reference back()       { return __sent.back(); }
    
  public:
    
    friend
    size_t hash_value(Sentence const& x);
    
    friend
    std::ostream& operator<<(std::ostream& os, const Sentence& x);
    friend
    std::istream& operator>>(std::istream& is, Sentence& x);
    
    friend
    bool operator==(const Sentence& x, const Sentence& y);
    friend
    bool operator!=(const Sentence& x, const Sentence& y);
    friend
    bool operator<(const Sentence& x, const Sentence& y);
    friend
    bool operator>(const Sentence& x, const Sentence& y);
    friend
    bool operator<=(const Sentence& x, const Sentence& y);
    friend
    bool operator>=(const Sentence& x, const Sentence& y);
    
  private:
    sent_type __sent;
  };
  
  inline
  size_t hash_value(Sentence const& x) { return utils::hashmurmur3<size_t>()(x.__sent.begin(), x.__sent.end(), 0); }
  
  inline
  bool operator==(const Sentence& x, const Sentence& y) { return x.__sent == y.__sent; }
  inline
  bool operator!=(const Sentence& x, const Sentence& y) { return x.__sent != y.__sent; }
  inline
  bool operator<(const Sentence& x, const Sentence& y) { return x.__sent < y.__sent; }
  inline
  bool operator>(const Sentence& x, const Sentence& y) { return x.__sent > y.__sent; }
  inline
  bool operator<=(const Sentence& x, const Sentence& y) { return x.__sent <= y.__sent; }
  inline
  bool operator>=(const Sentence& x, const Sentence& y) { return x.__sent >= y.__sent; }
  
  
  
};

namespace std
{
  inline
  void swap(cicada::Sentence& x, cicada::Sentence& y)
  {
    x.swap(y);
  }
};

#endif
