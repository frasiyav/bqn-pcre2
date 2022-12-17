#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>

#if UTF8
#define PCRE2_CODE_UNIT_WIDTH 8
#define CHAR_TYPE PCRE2_UCHAR8
#define BQN_MAKESTR bqn_makeC8Vec
#endif

#if UTF16
#define PCRE2_CODE_UNIT_WIDTH 16
#define CHAR_TYPE PCRE2_UCHAR16
#define BQN_MAKESTR bqn_makeC16Vec
#endif

#if UTF32
#define PCRE2_CODE_UNIT_WIDTH 32
#define CHAR_TYPE PCRE2_UCHAR32
#define BQN_MAKESTR bqn_makeC32Vec
#endif

#include <pcre2.h>

typedef uint64_t BQNV;
BQNV BQN_MAKESTR(size_t len, CHAR_TYPE* data);
BQNV bqn_makeObjVec(size_t len, const BQNV* data);
BQNV bqn_makeI32Vec(size_t len, const int32_t* data);
BQNV bqn_call2(BQNV f, BQNV w, BQNV x);
BQNV bqn_evalCStr(const char* str);

static void print_error(int code) {
    CHAR_TYPE message[256];
    if (pcre2_get_error_message(code, message, sizeof(message) / sizeof(CHAR_TYPE)))
        printf("Regex error: ");
        printf((const char *)message);
        printf("\n");
}

BQNV substring_list_to_bqnv(CHAR_TYPE **strings, PCRE2_SIZE *lengths, BQNV* stringlist, int rc){

    for (int i=0; i < rc; i++) {
        stringlist[i] = BQN_MAKESTR(lengths[i], strings[i]);
    }
    return bqn_makeObjVec(rc, stringlist);
}

int compile(CHAR_TYPE *pattern, pcre2_code **re,
    bool jit, bool utf, bool ucp,
    bool multiline, bool greedy, bool anchored,
    bool caseless, bool extended) {

    uint32_t options = 0;
    if (utf) options |= PCRE2_UTF;
    if (ucp) options |= PCRE2_UCP;
    if (multiline) options |= PCRE2_MULTILINE;
    if (!greedy) options |= PCRE2_UNGREEDY;
    if (anchored) options |= PCRE2_ANCHORED;
    if (caseless) options |= PCRE2_CASELESS;
    if (extended) options |= PCRE2_EXTENDED;

    int error;
    PCRE2_SIZE erroffset;

    *re = pcre2_compile(
        pattern, PCRE2_ZERO_TERMINATED,
        options,
        &error, &erroffset,
        NULL);

    if (!*re) {
        print_error(error);
        return 0;
    }

    if (jit) pcre2_jit_compile(*re, PCRE2_JIT_COMPLETE);

    return 1;
}

bool test(pcre2_code* re, CHAR_TYPE *input) {

    uint32_t options = PCRE2_NOTEMPTY | PCRE2_NOTEMPTY_ATSTART;

    PCRE2_SIZE offset = 0;
    pcre2_match_data *match_data = pcre2_match_data_create_from_pattern(re, NULL);

    int rc;
    rc = pcre2_match(
        re, input, PCRE2_ZERO_TERMINATED,
        offset, 
        options,
        match_data,
        NULL);

    pcre2_match_data_free(match_data);
    return rc > 0;
}

BQNV imatch(pcre2_code* re, CHAR_TYPE *input) {

    uint32_t options = PCRE2_NOTEMPTY | PCRE2_NOTEMPTY_ATSTART;

    PCRE2_SIZE offset = 0;
    pcre2_match_data *match_data = pcre2_match_data_create_from_pattern(re, NULL);

    PCRE2_SIZE* ovector;

    int rc;
    rc = pcre2_match(
        re, input, PCRE2_ZERO_TERMINATED,
        offset, 
        options,
        match_data,
        NULL);

    if (rc == PCRE2_ERROR_NOMATCH) {
        pcre2_match_data_free(match_data);
        return bqn_makeObjVec(0,NULL);
    }

    if (rc < 0) {
        switch (rc) {
            case PCRE2_ERROR_NOMATCH: break;
            default: printf("Matching error %d\n", rc); break;
        }
        pcre2_match_data_free(match_data);
        return bqn_makeObjVec(0,NULL);
    }

    if (rc == 0) printf("ovector size error\n");

    ovector = pcre2_get_ovector_pointer(match_data);
    BQNV *offsetpairlist = malloc(rc * sizeof(BQNV));
    int32_t opair[2];
    for (int i=0; i<rc; i++) {
        opair[0] = ovector[2*i];
        opair[1] = ovector[2*i+1];
        offsetpairlist[i] = bqn_makeI32Vec(2, opair);
    }

    BQNV ret = bqn_makeObjVec(rc, offsetpairlist);
    free(offsetpairlist);
    pcre2_match_data_free(match_data);
    return ret;
}

BQNV match(pcre2_code* re, CHAR_TYPE *input) {

    uint32_t options = PCRE2_NOTEMPTY | PCRE2_NOTEMPTY_ATSTART;

    PCRE2_SIZE offset = 0;
    pcre2_match_data *match_data = pcre2_match_data_create_from_pattern(re, NULL);

    CHAR_TYPE** listptr;
    PCRE2_SIZE* lengthsptr;

    int rc;
    rc = pcre2_match(
        re, input, PCRE2_ZERO_TERMINATED,
        offset, 
        options,
        match_data,
        NULL);

    if (rc == PCRE2_ERROR_NOMATCH) {
        pcre2_match_data_free(match_data);
        return bqn_makeObjVec(0,NULL);
    }

    if (rc < 0) {
        switch (rc) {
            case PCRE2_ERROR_NOMATCH: break;
            default: printf("Matching error %d\n", rc); break;
        }
        pcre2_match_data_free(match_data);
        return bqn_makeObjVec(0,NULL);
    }

    if (rc == 0) printf("ovector size error\n");

    BQNV *stringlist = malloc(rc * sizeof(BQNV));
    pcre2_substring_list_get(match_data, &listptr, &lengthsptr);

    BQNV ret = substring_list_to_bqnv(listptr, lengthsptr, stringlist, rc);
    free(stringlist);
    pcre2_match_data_free(match_data);

    return ret;
}

BQNV matchall(pcre2_code* re, CHAR_TYPE *input, bool overlapping) {

    uint32_t options = PCRE2_NOTEMPTY | PCRE2_NOTEMPTY_ATSTART;

    BQNV retlist = bqn_makeObjVec(0,NULL);
    BQNV append = bqn_evalCStr("∾⟜<");

    PCRE2_SIZE *ovector;
    PCRE2_SIZE offset = 0;
    pcre2_match_data *match_data = pcre2_match_data_create_from_pattern(re, NULL);

    CHAR_TYPE** listptr;
    PCRE2_SIZE* lengthsptr;

    uint32_t ovector_count = pcre2_get_ovector_count(match_data);
    BQNV *stringlist = malloc(ovector_count * sizeof(BQNV));

    int rc;
    for (;;) {
        rc = pcre2_match(
            re, input, PCRE2_ZERO_TERMINATED,
            offset, 
            options,
            match_data,
            NULL);

        if (rc < 0) {
            switch (rc) {
                case PCRE2_ERROR_NOMATCH: break;
                default: printf("Matching error %d\n", rc); break;
            }
            break;
        }

        ovector = pcre2_get_ovector_pointer(match_data);

        pcre2_substring_list_get(match_data, &listptr, &lengthsptr);
        retlist = bqn_call2(append, retlist, substring_list_to_bqnv(listptr, lengthsptr, stringlist, rc));
        pcre2_substring_list_free((PCRE2_SPTR*)listptr);
        
        offset = overlapping ? offset+1: ovector[1];
    }
        
    free(stringlist);
    pcre2_match_data_free(match_data);
    return retlist;
}

BQNV replace(pcre2_code* re, CHAR_TYPE *replacement, CHAR_TYPE *input, const size_t initbuffersize, bool global, bool extended) {

    uint32_t options = PCRE2_SUBSTITUTE_EXTENDED | PCRE2_SUBSTITUTE_OVERFLOW_LENGTH;
    if (global) options |= PCRE2_SUBSTITUTE_GLOBAL;
    if (extended) options |= PCRE2_SUBSTITUTE_EXTENDED;

    PCRE2_SIZE *ovector;
    PCRE2_SIZE offset = 0;

    pcre2_match_data *match_data = pcre2_match_data_create_from_pattern(re, NULL);
    size_t outlength = initbuffersize;
    CHAR_TYPE *output = malloc(outlength * sizeof(CHAR_TYPE));

    int rc;
    for (;;) {
        rc = pcre2_substitute(
            re, input, PCRE2_ZERO_TERMINATED,
            offset,
            options,
            match_data, NULL,
            replacement, PCRE2_ZERO_TERMINATED,
            output, &outlength);

        if (rc == PCRE2_ERROR_NOMEMORY) {
            free(output);
            output = malloc(outlength * sizeof(CHAR_TYPE));
        } else break;
    }

    pcre2_match_data_free(match_data);
    BQNV retstring = BQN_MAKESTR(outlength, output);
    free(output);
    return retstring;
}

void re_free(pcre2_code* re) {
    pcre2_code_free(re);
}
