#include <ruby.h>
#include <stdio.h>

struct matrix
{
    int n;
    int m;

    double* data;
};

void matrix_free(void* data)
{
	free(((*(struct matrix*)data)).data);
    free(data);
}

size_t matrix_size(const void* data)
{
	return sizeof(struct matrix);
}

static const rb_data_type_t matrix_type = 
{
	.wrap_struct_name = "matrix",
	.function = 
    {
		.dmark = NULL,
		.dfree = matrix_free,
		.dsize = matrix_size,
	},
	.data = NULL,
	.flags = RUBY_TYPED_FREE_IMMEDIATELY,
};

VALUE matrix_alloc(VALUE self)
{
	struct matrix* mtx = malloc(sizeof(struct matrix));
	
	return TypedData_Wrap_Struct(self, &matrix_type, mtx);
}

VALUE matrix_initialize(VALUE self, VALUE m, VALUE n)
{
	struct matrix* data;
    
	TypedData_Get_Struct(self, struct matrix, &matrix_type, data);

	data->m = m;
	data->n = n;
	data->data = malloc(m * n * sizeof(double));

	return self;
}

double raise_rb_value_to_double(VALUE v)
{
    if(RB_FLOAT_TYPE_P(v) || FIXNUM_P(v)
        || RB_TYPE_P(v, T_BIGNUM))
        return NUM2DBL(v);

    rb_raise(rb_eTypeError, "Matrix error: Is not number");
    return 0;
}

VALUE matrix_set(VALUE self, VALUE m, VALUE n, VALUE v)
{
    double x = raise_rb_value_to_double(v);
	struct matrix* data;
	TypedData_Get_Struct(self, struct matrix, &matrix_type, data);
    data->data[m + data->m * n] = x;
    return Qnil;
}

void matrix_get(VALUE self, VALUE m, VALUE n)
{
	struct matrix* data;
	TypedData_Get_Struct(self, struct matrix, &matrix_type, data);
    return DBL2NUM(data->data[m + data->m * n]);
}

void Init_silicium()
{
    VALUE  mod = rb_define_module("Silicium");
	VALUE cMatrix = rb_define_class_under(mod, "Matrix", rb_cObject);

	rb_define_alloc_func(cMatrix, matrix_alloc);

	rb_define_method(cMatrix, "initialize", matrix_initialize, 2);
	rb_define_method(cMatrix, "[]", matrix_get, 2);
	rb_define_method(cMatrix, "[]=", matrix_set, 3);
}