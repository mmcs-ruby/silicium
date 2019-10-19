#include <ruby.h>
#include <stdio.h>

static VALUE matrix_eTypeError;
static VALUE matrix_eIndexError;
static VALUE cMatrix;

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

double raise_rb_value_to_double(VALUE v)
{
    if(RB_FLOAT_TYPE_P(v) || FIXNUM_P(v)
        || RB_TYPE_P(v, T_BIGNUM))
        return NUM2DBL(v);

    rb_raise(matrix_eTypeError, "Value is not number");
    return 0;
}

int raise_rb_value_to_int(VALUE v)
{
    if(FIXNUM_P(v))
        return NUM2INT(v);

    rb_raise(matrix_eTypeError, "Index is not integer");
    return 0;
}

void raise_check_range(int v, int min, int max)
{
    if(v < min || v >= max)
        rb_raise(matrix_eIndexError, "Index out of range");
}

void c_matrix_init(struct matrix* mtr, int m, int n)
{
    mtr->m = m;
    mtr->n = n;
    mtr->data = malloc(m * n * sizeof(double));
}

VALUE matrix_initialize(VALUE self, VALUE m, VALUE n)
{
	struct matrix* data;
    int int_m = raise_rb_value_to_int(m);
    int int_n = raise_rb_value_to_int(n);

    if(int_m <= 0 || int_n <= 0)
        rb_raise(matrix_eIndexError, "Size cannot be negative or zero");

	TypedData_Get_Struct(self, struct matrix, &matrix_type, data);

    c_matrix_init(data, int_m, int_n);

	return self;
}

VALUE matrix_set(VALUE self, VALUE m, VALUE n, VALUE v)
{
    int int_m = raise_rb_value_to_int(m);
    int int_n = raise_rb_value_to_int(n);
    double x = raise_rb_value_to_double(v);

	struct matrix* data;
	TypedData_Get_Struct(self, struct matrix, &matrix_type, data);

    raise_check_range(int_m, 0, data->m);
    raise_check_range(int_n, 0, data->n);

    data->data[int_m + data->m * int_n] = x;
}

VALUE matrix_get(VALUE self, VALUE m, VALUE n)
{
    int int_m = raise_rb_value_to_int(m);
    int int_n = raise_rb_value_to_int(n);

	struct matrix* data;
	TypedData_Get_Struct(self, struct matrix, &matrix_type, data);

    raise_check_range(int_m, 0, data->m);
    raise_check_range(int_n, 0, data->n);

    return DBL2NUM(data->data[int_m + data->m * int_n]);
}

// A - matrix k x n
// B - matrix m x k
// C - matrix m x n
void c_matrix_multiply(int n, int k, int m, const double* A, const double* B, double* C)
{
    for(int i = 0; i < m; ++i)
        for(int j = 0; j < n; ++j)
        {
            C[i + m * j] = 0;
            for(int t = 0; t < k; ++t)
                C[i + m * j] += A[t + k * j] * B[i + m * t];
        }
}

VALUE matrix_multiply(VALUE self, VALUE other)
{

	struct matrix* A;
    struct matrix* B;
	TypedData_Get_Struct(self, struct matrix, &matrix_type, A);
	TypedData_Get_Struct(other, struct matrix, &matrix_type, B);

    if(A->m != B->n)
        rb_raise(matrix_eIndexError, "First columns differs from second rows");

    int m = B->m;
    int k = A->m;
    int n = A->n;

    struct matrix* C;
    VALUE result = TypedData_Make_Struct(cMatrix, struct matrix, &matrix_type, C);

    c_matrix_init(C, m, n);
    c_matrix_multiply(n, k, m, A->data, B->data, C->data);

    return result;
}

void Init_silicium()
{
    VALUE  mod = rb_define_module("Silicium");
	cMatrix = rb_define_class_under(mod, "Matrix", rb_cData);

    matrix_eTypeError  = rb_define_class_under(cMatrix, "TypeError",  rb_eTypeError);
    matrix_eIndexError = rb_define_class_under(cMatrix, "IndexError", rb_eIndexError);


	rb_define_alloc_func(cMatrix, matrix_alloc);

	rb_define_method(cMatrix, "initialize", matrix_initialize, 2);
	rb_define_method(cMatrix, "get", matrix_get, 2);
	rb_define_method(cMatrix, "set", matrix_set, 3);
	rb_define_method(cMatrix, "*", matrix_multiply, 1);
}