#include "scam.h"

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


