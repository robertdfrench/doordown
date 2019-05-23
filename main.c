/* This file was adapted from libmicrohttpd, and is thus probably GPL */
#include <microhttpd.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <door.h>
#include <err.h>
#include <fcntl.h>

#define PAGE "<html><head><title>libmicrohttpd demo</title>"\
             "</head><body>libmicrohttpd demo</body></html>"

int door_handle = 0;

static int ahc_echo(void * cls,
		    struct MHD_Connection * connection,
		    const char * url,
		    const char * method,
                    const char * version,
		    const char * upload_data,
		    size_t * upload_data_size,
                    void ** ptr) {
  static int dummy;
  const char * page = cls;
  struct MHD_Response * response;
  int ret;

  if (0 != strcmp(method, "GET")) return MHD_NO;
  if (&dummy != *ptr) {
    /* The first time only the headers are valid,
       do not respond in the first round... */
    *ptr = &dummy;
    return MHD_YES;
  }
  if (0 != *upload_data_size) return MHD_NO;

  *ptr = NULL; /* clear context pointer */

  door_arg_t args = {0};
  int result = door_call(door_handle, &args);
  if (result == -1) err(1, "My door request could not be placed");

  response = MHD_create_response_from_buffer(strlen(args.data_ptr), (void*) args.data_ptr, MHD_RESPMEM_PERSISTENT);
  					      
  ret = MHD_queue_response(connection, MHD_HTTP_OK, response);
  MHD_destroy_response(response);
  return ret;
}

int main(int argc, char ** argv) {
  struct MHD_Daemon* d;
  if (argc != 2) {
    printf("%s PORT\n",argv[0]);
    return 1;
  }

  door_handle = open("webapp.door", O_RDONLY);
  if (door_handle == -1) err(1, "Could not open door");

  d = MHD_start_daemon(MHD_USE_THREAD_PER_CONNECTION,
		       atoi(argv[1]),
		       NULL,
		       NULL,
		       &ahc_echo,
		       PAGE,
		       MHD_OPTION_END);
  if (d == NULL)
    return 1;
  (void) getc (stdin);
  MHD_stop_daemon(d);
  return 0;
}
