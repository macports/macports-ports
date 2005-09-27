/* $Id: buffer.c,v 1.1 2005/09/27 07:34:57 mww Exp $
 *
 * Copyright 2005, PostgresPy Project.
 * http://python.projects.postgresql.org
 *
 *//*
 * PQ message readers. Blocking dependent, and passive.
 *
 * PQ messages normally take the form type, (size), data.
 * Passive and Block constructs a tuple from the read data.
 */
#ifdef WIN32
#include <winsock.h>
#else
#include <netinet/in.h>
#endif
#include <Python.h>
#include <structmember.h>

struct p_list
{
	PyObject *data; /* PyString pushed onto the buffer */
	struct p_list *next;
};

struct p_buffer
{
	PyObject_HEAD

	PyObject *message; /* NULL if the header has yet to be read */
	char msg_type;
	uint32_t msg_length;

	uint32_t position; /* position in first */
	uint32_t total; /* total data in the list */
	struct p_list *first, *last;
};

/*
 * Reset the buffer
 */
static void
p_truncate(struct p_buffer *pb)
{
	struct p_list *pl = pb->first;

	pb->total = 0;
	pb->message = NULL;
	pb->msg_type = '\0';
	pb->msg_length = 0;
	pb->position = 0;
	pb->first = NULL;
	pb->last = NULL;

	while (pl != NULL)
	{
		struct p_list *next = pl->next;
		Py_DECREF(pl->data);
		free(pl);
		pl = next;
	}
}

static void
p_dealloc(PyObject *self)
{
	struct p_buffer *pb = ((struct p_buffer *) self);
	p_truncate(pb);
	self->ob_type->tp_free(self);
}

static PyObject *
p_new(PyTypeObject *subtype, PyObject *args, PyObject *kw)
{
	static char *kwlist[] = {NULL};
	struct p_buffer *pb;
	PyObject *rob;

	if (PyArg_ParseTupleAndKeywords(args, kw, "", kwlist) < 0)
		return(NULL);

	rob = subtype->tp_alloc(subtype, 0);
	pb = ((struct p_buffer *) rob);
	pb->total = 0;
	pb->message = NULL;
	pb->msg_type = '\0';
	pb->msg_length = 0;
	pb->position = 0;
	pb->first = NULL;
	pb->last = NULL;
	return(rob);
}

static void
p_read(struct p_buffer *pb, uint32_t amount, char *buf)
{
	struct p_list *pl = pb->first;
	uint32_t pos = pb->position;
	uint32_t dread = 0;

	while (dread < amount)
	{
		struct p_list *next = pl->next;
		char *src = (PyString_AS_STRING(pl->data) + pos);
		unsigned long datasz = PyString_GET_SIZE(pl->data);
		unsigned long left_to_read = amount - dread;
		unsigned long this_read = datasz - pos;

		if (left_to_read < this_read)
			this_read = left_to_read;
		memcpy(buf, src, this_read);
		buf = buf + this_read;
		dread = dread + this_read;

		if (this_read + pos < datasz)
		{
			pos = pb->position = this_read + pos;
			break;
		}
		else
		{
			pos = pb->position = 0;
			Py_DECREF(pl->data);
			free(pl);
			pl = pb->first = next;
			if (pl == NULL)
			{
				pb->last = NULL;
				break;
			}
		}
	}

	pb->total = pb->total - dread;
}

static PyObject *
p_call(PyObject *self, PyObject *args, PyObject *kw)
{
	static char *kwlist[] = {"data", NULL};
	struct p_buffer *pb;
	PyObject *data, *rob = NULL;

	if (PyArg_ParseTupleAndKeywords(args, kw, "S", kwlist, &data) < 0)
		return(NULL);
	pb = ((struct p_buffer *) self);

	if (PyString_GET_SIZE(data) > 0)
	{
		struct p_list *pl;
		pb->total = pb->total + PyString_GET_SIZE(data);
		pl = malloc(sizeof(struct p_list));
		if (pl == NULL)
		{
			PyErr_SetString(PyExc_MemoryError,
				"could not allocate memory for Passive buffer list");
			return(NULL);
		}
		pl->data = data;
		Py_INCREF(data);
		pl->next = NULL;
		if (pb->last == NULL)
			pb->first = pb->last = pl;
		else
		{
			pb->last->next = pl;
			pb->last = pl;
		}
	}

	if (pb->message == NULL)
	{
		char header[5];

		if (pb->total < 5)
		{
			Py_INCREF(Py_None);
			return(Py_None);
		}

		pb->message = PyTuple_New(2);
		if (pb->message == NULL)
			return(NULL);

		p_read(pb, 5, header);
		pb->msg_type = header[0];
		pb->msg_length = ntohl(*((uint32_t *) (header + 1)));
		if (pb->msg_length < 4)
		{
			PyErr_Format(PyExc_ValueError,
				"invalid message size '%d'", pb->msg_length);
			p_truncate(pb);
			return(NULL);
		}
		pb->msg_length = pb->msg_length - 4;
	}

	if (pb->total < pb->msg_length)
	{
		Py_INCREF(Py_None);
		rob = Py_None;
	}
	else
	{
		PyObject *mt, *md;
		char *buf = NULL;
		if (pb->msg_length > 0)
		{
			buf = malloc(pb->msg_length);
			if (buf == NULL)
			{
				PyErr_SetString(PyExc_MemoryError,
					"could not allocate memory for message data");
				return(NULL);
			}
			p_read(pb, pb->msg_length, buf);
		}
		mt = PyString_FromStringAndSize(&pb->msg_type, 1);
		if (mt == NULL)
		{
			if (buf != NULL) free(buf);
			return(NULL);
		}
		/*
		 * XXX: Flash Flood Warning. Bad mojo.
		 */
		md = PyString_FromStringAndSize(buf, (int) pb->msg_length);
		if (buf != NULL) free(buf);
		if (md == NULL)
		{
			Py_DECREF(mt);
			return(NULL);
		}

		PyTuple_SET_ITEM(pb->message, 0, mt);
		PyTuple_SET_ITEM(pb->message, 1, md);
		rob = pb->message;
		pb->message = NULL;
		pb->msg_length = 0;
		pb->msg_type = '\0';
	}

	return(rob);
}

PyTypeObject passive_Type = {
	PyObject_HEAD_INIT(NULL)
	0,										/* ob_size */
	"buffer.Passive",					/* tp_name */
	sizeof(struct p_buffer),		/* tp_basicsize */
	0,										/* tp_itemsize */
	p_dealloc,							/* tp_dealloc */
	NULL,									/* tp_print */
	NULL,									/* tp_getattr */
	NULL,									/* tp_setattr */
	NULL,									/* tp_compare */
	NULL,									/* tp_repr */
	NULL,									/* tp_as_number */
	NULL,									/* tp_as_sequence */
	NULL,									/* tp_as_mapping */
	NULL,									/* tp_hash */
	p_call,								/* tp_call */
	NULL,									/* tp_str */
	NULL,									/* tp_getattro */
	NULL,									/* tp_setattro */
	NULL,									/* tp_as_buffer */
	Py_TPFLAGS_DEFAULT,			   /* tp_flags */
	NULL,									/* tp_doc */
	NULL,									/* tp_traverse */
	NULL,									/* tp_clear */
	NULL,									/* tp_richcompare */
	0,										/* tp_weaklistoffset */
	NULL,									/* tp_iter */
	NULL,									/* tp_iternext */
	NULL,									/* tp_methods */
	NULL,									/* tp_members */
	NULL,									/* tp_getset */
	NULL,									/* tp_base */
	NULL,									/* tp_dict */
	NULL,									/* tp_descr_get */
	NULL,									/* tp_descr_set */
	0,										/* tp_dictoffset */
	NULL,									/* tp_init */
	NULL,									/* tp_alloc */
	p_new,								/* tp_new */
	NULL,									/* tp_free */
};

static PyObject *
read_message(PyObject *self, PyObject *reader)
{
	PyObject *rob;
	PyObject *head, *ts, *data;
	char headc[5];
	uint32_t length = 5;

	head = PyObject_CallFunction(reader, "l", length);
	if (head == NULL)
		return(NULL);
	rob = PyObject_Str(head);
	Py_DECREF(head);
	head = rob;
	if (PyString_GET_SIZE(head) < 5)
	{
		Py_DECREF(head);
		Py_INCREF(Py_None);
		return(Py_None);
	}

	memcpy(headc, PyString_AS_STRING(head), 5);
	length = ntohl(*((uint32_t *) (headc + 1)));
	Py_DECREF(head);

	if (length < 4)
	{
		PyErr_Format(PyExc_ValueError, "invalid message size '%d'", length);
		return(NULL);
	}
	length = length - 4;

	data = PyObject_CallFunction(reader, "l", length);
	if (data == NULL) return(NULL);
	head = PyObject_Str(data);
	Py_DECREF(data);
	if (head == NULL) return(NULL);
	data = head;

	if (PyString_GET_SIZE(data) != length)
	{
		Py_DECREF(data);
		Py_INCREF(Py_None);
		return(Py_None);
	}

	ts = PyString_FromStringAndSize(headc, 1);
	if (ts == NULL) return(NULL);

	rob = PyTuple_New(2);
	PyTuple_SET_ITEM(rob, 0, ts);
	PyTuple_SET_ITEM(rob, 1, data);
	return(rob);
}

static PyMethodDef Methods[] = {
	{"Block", (PyCFunction) read_message, METH_O,
	"Execute the given callable within a transaction"},
	{NULL}
};

extern PyMODINIT_FUNC
initbuffer(void)
{
	PyObject *mod;

	mod = Py_InitModule3("buffer", Methods, "PQ Message buffer utilities");
	if (mod == NULL) return;

	if (PyType_Ready(&passive_Type) < 0)
		return;
	PyModule_AddObject(mod, "Passive", (PyObject *) &passive_Type);
}
/*
 * vim: ts=3:sw=3:noet:
 */
