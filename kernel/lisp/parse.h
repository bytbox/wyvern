#ifndef LISP_PARSE_H
#define LISP_PARSE_H

struct List {

};

struct Atom {

};

struct S_Expr {
	enum {ATOM, LIST} type;
	union {
		struct List *list;
		struct Atom *atom;
	} data;
};

#endif /* !LISP_PARSE_H */

