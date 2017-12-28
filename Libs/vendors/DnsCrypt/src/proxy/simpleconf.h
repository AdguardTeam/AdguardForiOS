#ifndef __SIMPLECONF_H__
#define __SIMPLECONF_H__ 1

#include <stdlib.h>

typedef struct SimpleConfEntry_ {
    const char *in;
    const char *out;
} SimpleConfEntry;

typedef enum SimpleConfSpecialHandlerResult_ {
    SC_SPECIAL_HANDLER_RESULT_UNDEFINED,
    SC_SPECIAL_HANDLER_RESULT_NEXT,
    SC_SPECIAL_HANDLER_RESULT_ERROR,
    SC_SPECIAL_HANDLER_RESULT_INCLUDE,
} SimpleConfSpecialHandlerResult;

typedef SimpleConfSpecialHandlerResult (*SimpleConfSpecialHandler)
    (void **output_p, const char *arg, void *user_data);

typedef struct SimpleConfConfig_ {
    void                     *user_data;
    SimpleConfSpecialHandler  special_handler;
} SimpleConfConfig;

int sc_build_command_line_from_file(const char *file_name,
                                    const SimpleConfConfig *config,
                                    const SimpleConfEntry entries[],
                                    size_t entries_count, char *app_name,
                                    int *argc_p, char ***argv_p);

void sc_argv_free(int argc, char *argv[]);

#endif
