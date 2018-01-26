# bash functions to mimic try-catch behavior in bash
# EXAMPLE:
# try myscript.sh
# if_success follow_up.sh
# if_success follow_up2.sh
# catch error_script.sh
# if_failure follow_failure.sh

# export variables to be called upon elsewhere
export TRY_ERROR=""
export EXIT_CODE=0

function get_exit_status(){
    # @Desc:    function to retrieve exit status of previously run command
    EXIT_CODE=$?
}

function echo_error(){
    # @Desc:    function to echo to stderr
    # @Params:  string to echo to stderr
    if [ -z ${@:1:1} ]
    then
        :
    else
        (echo "$@" >&2)
    fi
}

function try(){
    # @Desc:    function to execute bash command and capture its exit status
    # @Params:  1+ - command to execute
    TRY_ERROR=$(("$@") 3>&1 2>&3)
    get_exit_status
    if [ $EXIT_CODE -lt 1 ]
    then
        echo_error $TRY_ERROR
    fi
}

function catch(){
    # @Desc:    function to excecute command if previous command has failed
    #   does not change EXIT_CODE
    # @Params: 1+ - command to execute
    if [ $EXIT_CODE -gt 0 ]
    then
        if [ -z $1 ]
        then
            TRY_ERROR=""
        else
            "$@"
        fi
    fi
}

function if_success(){
    # @Desc:    function to force try-catch behavior. Only execute code
    #   if previous command has been successfully executed
    # @Params:  1+ - command to execute
    if [ $EXIT_CODE -lt 1 ]
    then
        try "$@"
    fi
}

function if_failure(){
    # @Desc:    function only executes command if EXIT_CODE is failure (1+)
    # @Params:  1+ - command to execute
    if [ $EXCEPT -gt 0 ]
    then
        "$@"
    fi
}
