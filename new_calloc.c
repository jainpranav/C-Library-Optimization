#ifndef _MALLOC_INTERNAL
#define _MALLOC_INTERNAL
#include <malloc.h>
#endif

/* Allocate an array of NMEMB elements each SIZE bytes long.
   The entire array is initialized to zeros.  */
__ptr_t
calloc (nmemb, size)
     register __malloc_size_t nmemb;
     register __malloc_size_t size;
{
  register __ptr_t result = malloc (nmemb * size);

  if (result != NULL)
    (void) memset (result, 0, nmemb * size);

  return result;
}
