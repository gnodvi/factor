#include "factor.h"

void fatal_error(char* msg, CELL tagged)
{
	fprintf(stderr,"Fatal error: %s %ld\n",msg,tagged);
	exit(1);
}

void critical_error(char* msg, CELL tagged)
{
	fprintf(stderr,"Critical error: %s %ld\n",msg,tagged);
	save_image("factor.crash.image");
	exit(1);
}

void fix_stacks(void)
{
	if(STACK_UNDERFLOW(ds,ds_bot)
		|| STACK_OVERFLOW(ds,ds_bot))
		reset_datastack();
	if(STACK_UNDERFLOW(cs,cs_bot)
		|| STACK_OVERFLOW(cs,cs_bot))
		reset_callstack();
}

void throw_error(CELL error)
{
	fix_stacks();

	dpush(error);
	/* Execute the 'throw' word */
	call(userenv[BREAK_ENV]);

	/* Return to run() method */
	siglongjmp(toplevel,1);
}

void general_error(CELL error, CELL tagged)
{
	CONS* c = cons(error,tag_cons(cons(tagged,F)));
	if(userenv[BREAK_ENV] == 0)
	{
		/* Crash at startup */
		fprintf(stderr,"Error thrown before BREAK_ENV set\n");
		fprintf(stderr,"Error #%ld\n",to_fixnum(error));
		if(error == ERROR_TYPE)
		{
			fprintf(stderr,"Type #%ld\n",to_fixnum(
				untag_cons(tagged)->car));
			fprintf(stderr,"Got type #%ld\n",type_of(
				untag_cons(tagged)->cdr));
		}
		exit(1);
	}
	throw_error(tag_cons(c));
}

void type_error(CELL type, CELL tagged)
{
	CONS* c = cons(tag_fixnum(type),tag_cons(cons(tagged,F)));
	general_error(ERROR_TYPE,tag_cons(c));
}

void range_error(CELL tagged, CELL index, CELL max)
{
	CONS* c = cons(tagged,tag_cons(cons(tag_fixnum(index),
		tag_cons(cons(tag_fixnum(max),F)))));
	general_error(ERROR_RANGE,tag_cons(c));
}
